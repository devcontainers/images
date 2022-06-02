# [{{definition}}](https://github.com/{{repository}}/tree/main/src/{{definition}})
{{#if annotation}}
{{{annotation}}}
{{/if}}

**Image version:** {{version}}

**Source release/branch:** [{{release}}](https://github.com/{{repository}}/tree/{{release}}/src/{{definition}})

{{#if hasVariants}}
**Definition variations:**
{{#each variants}}
- [{{this}}](#variant-{{anchor this}})
{{/each}}

{{/if}}