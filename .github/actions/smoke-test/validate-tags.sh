#!/bin/bash

# Script to validate that all base image tags in manifest.json exist upstream
set -e

IMAGE="$1"
MANIFEST_FILE="src/${IMAGE}/manifest.json"

if [[ ! -f "$MANIFEST_FILE" ]]; then
    echo "ERROR: Manifest file not found: $MANIFEST_FILE"
    exit 1
fi

echo "(*) Validating base image tags for ${IMAGE}..."

# Extract base image pattern from manifest.json
BASE_IMAGE=$(jq -r '.dependencies.image // empty' "$MANIFEST_FILE")

if [[ -z "$BASE_IMAGE" ]]; then
    echo "WARNING: No base image found in dependencies.image, skipping validation"
    exit 0
fi

echo "Base image pattern: $BASE_IMAGE"

# Extract variants from manifest.json (may be empty)
VARIANTS=$(jq -r '.variants[]?' "$MANIFEST_FILE" 2>/dev/null || true)

# Track validation results
INVALID_TAGS=()
VALID_TAGS=()

# Function to check if a Docker image tag exists
check_image_exists() {
    local image_tag="$1"
    echo "  Checking: $image_tag"
    
    if docker manifest inspect "$image_tag" > /dev/null 2>&1; then
        echo "    ✓ Valid"
        return 0
    else
        echo "    ✗ Invalid - tag does not exist"
        return 1
    fi
}

# Check if this image has variants
if [[ -n "$VARIANTS" ]]; then
    echo "Found variants, validating each one..."
    # Check each variant
    for variant in $VARIANTS; do
        image_tag="$BASE_IMAGE"
        
        # Replace ${VARIANT} placeholder with actual variant
        image_tag=$(echo "$image_tag" | sed "s/\${VARIANT}/$variant/g")
        
        # Check if there are variantBuildArgs for this variant
        VARIANT_BUILD_ARGS=$(jq -r ".build.variantBuildArgs.\"$variant\" // empty" "$MANIFEST_FILE" 2>/dev/null)

        if [[ -n "$VARIANT_BUILD_ARGS" && "$VARIANT_BUILD_ARGS" != "empty" && "$VARIANT_BUILD_ARGS" != "null"  ]]; then
            echo "  Found build args for variant: $variant"
            # Extract build args and replace placeholders
            while IFS= read -r build_arg; do
                if [[ -n "$build_arg" ]]; then
                    arg_name=$(echo "$build_arg" | cut -d':' -f1 | tr -d '"')
                    arg_value=$(echo "$build_arg" | cut -d':' -f2- | tr -d '"' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
                    image_tag=$(echo "$image_tag" | sed "s/\${$arg_name}/$arg_value/g")
                fi
            done < <(echo "$VARIANT_BUILD_ARGS" | jq -r 'to_entries[] | "\(.key):\(.value)"' 2>/dev/null)
        elif [[ "$image_tag" == *'${BASE_IMAGE_VERSION_CODENAME}'* ]]; then
            echo "  Using variant name '$variant' as BASE_IMAGE_VERSION_CODENAME"
            image_tag=$(echo "$image_tag" | sed "s/\${BASE_IMAGE_VERSION_CODENAME}/$variant/g")
        fi
        
        if check_image_exists "$image_tag"; then
            VALID_TAGS+=("$variant")
        else
            INVALID_TAGS+=("$variant")
        fi
    done
else
    echo "No variants found, validating single base image..."
    if check_image_exists "$BASE_IMAGE"; then
        VALID_TAGS+=("base")
    else
        INVALID_TAGS+=("base")
    fi
fi

# Report results
echo ""
echo "=== Validation Results ==="
echo "Valid $(if [[ -n "$VARIANTS" ]]; then echo "variants"; else echo "base images"; fi) (${#VALID_TAGS[@]}):"

for tag in "${VALID_TAGS[@]}"; do
    if [[ "$tag" == "base" ]]; then
        echo "  ✓ $BASE_IMAGE"
    else
        echo "  ✓ $tag"
    fi
done

if [[ ${#INVALID_TAGS[@]} -gt 0 ]]; then
    echo ""
    echo "Invalid $(if [[ -n "$VARIANTS" ]]; then echo "variants"; else echo "base images"; fi) (${#INVALID_TAGS[@]}):"
    
    for tag in "${INVALID_TAGS[@]}"; do
        if [[ "$tag" == "base" ]]; then
            echo "  ✗ $BASE_IMAGE"
        else
            echo "  ✗ $tag"
        fi
    done
    echo ""
    echo "ERROR: Found ${#INVALID_TAGS[@]} invalid base image tags!"
    echo "Please verify these tags exist upstream before proceeding."
    exit 1
fi

echo ""
echo "✓ All base image tags are valid!"