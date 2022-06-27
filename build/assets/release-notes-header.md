# [{{image}}](https://github.com/{{repository}}/tree/main/src/{{image}})
{{#if annotation}}
{{{annotation}}}
{{/if}}

**Image version:** {{version}}

**Source release/branch:** [{{release}}](https://github.com/{{repository}}/tree/{{release}}/src/{{image}})

{{#if hasVariants}}
**Image variations:**
{{#each variants}}
- [{{this}}](#variant-{{anchor this}})
{{/each}}

{{/if}}