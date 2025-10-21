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
    local variant_name="$2"
    echo "  Checking: $image_tag"
    
    # Try to pull manifest without downloading the image
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
        # Replace ${VARIANT} placeholder with actual variant
        image_tag=$(echo "$BASE_IMAGE" | sed "s/\${VARIANT}/$variant/g")
        
        if check_image_exists "$image_tag" "$variant"; then
            VALID_TAGS+=("$variant")
        else
            INVALID_TAGS+=("$variant")
        fi
    done
else
    echo "No variants found, validating single base image..."
    # No variants, just check the base image directly
    if check_image_exists "$BASE_IMAGE" "base"; then
        VALID_TAGS+=("base")
    else
        INVALID_TAGS+=("base")
    fi
fi

# Report results
echo ""
echo "=== Validation Results ==="
if [[ -n "$VARIANTS" ]]; then
    echo "Valid variants (${#VALID_TAGS[@]}):"
else
    echo "Valid base images (${#VALID_TAGS[@]}):"
fi

for tag in "${VALID_TAGS[@]}"; do
    if [[ "$tag" == "base" ]]; then
        echo "  ✓ $BASE_IMAGE"
    else
        echo "  ✓ $tag"
    fi
done

if [[ ${#INVALID_TAGS[@]} -gt 0 ]]; then
    echo ""
    if [[ -n "$VARIANTS" ]]; then
        echo "Invalid variants (${#INVALID_TAGS[@]}):"
    else
        echo "Invalid base images (${#INVALID_TAGS[@]}):"
    fi
    
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