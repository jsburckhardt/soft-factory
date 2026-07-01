# 00 Excalidraw Generation Workflow

This reference defines the required behavior for generating Excalidraw diagrams.

## Scope

The skill MUST output valid Excalidraw JSON that opens in VS Code's Excalidraw extension.

The skill MUST use unique IDs for every element.

The skill MUST ensure bound elements reference valid IDs.

The skill MUST calculate positions and sizes for visually balanced layouts.

The skill MUST use the Excalidraw property names and value formats expected by Excalidraw files.

The skill MUST use arrows with valid start and end bindings when creating connected diagrams.

The skill MUST use `boundElements` on shapes and `containerId` on text when adding text to shapes.

The skill SHOULD search existing Excalidraw files to match repository styling conventions.

The skill SHOULD maintain at least 20px gaps between elements.

## Required inputs

The user SHOULD provide the diagram type, elements to include, relationships, layout preferences, color coding, and any reference files.

The user MAY provide an output path.

## Required outputs

The skill MUST return complete Excalidraw JSON.

When an output path is provided, the skill MUST write the JSON to that path.

## Success and error outcomes

Success means the generated file has type `excalidraw`, version `2`, valid elements, app state, and files object.

Error outcomes MUST identify missing diagram requirements, invalid bindings, invalid JSON, or unwritable output paths.
