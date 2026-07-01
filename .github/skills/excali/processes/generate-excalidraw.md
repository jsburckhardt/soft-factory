<instructions>
You MUST generate valid Excalidraw JSON.
You MUST use unique element IDs.
You MUST keep bound element references valid.
You MUST create balanced layouts from the requested diagram.
You MUST search existing diagrams when matching style is requested.
You MUST write the output file when the user provides a path.
</instructions>

<constants>
DEFAULT_BACKGROUND: "#ffffff"
DEFAULT_GRID_SIZE: 20
DEFAULT_VERSION: 2
MIN_ELEMENT_GAP: 20
</constants>

<formats>
<format id="EXCALIDRAW_FILE_V1" name="Excalidraw JSON Document" purpose="Return a complete Excalidraw document.">
<EXCALIDRAW_JSON>
WHERE:
- <EXCALIDRAW_JSON> is String; valid Excalidraw JSON with type excalidraw, version 2, elements, appState, and files.
</format>
</formats>

<runtime>
DIAGRAM_DESCRIPTION: ""
ELEMENTS: []
OUTPUT_PATH: ""
STYLE_PATTERNS: {}
</runtime>

<triggers>
<trigger event="user_message" target="generate-excalidraw" />
</triggers>

<processes>
<process id="generate-excalidraw" name="Generate Excalidraw diagram">
RUN `parse-diagram-request`
IF DIAGRAM_DESCRIPTION contains "existing" OR DIAGRAM_DESCRIPTION contains "sample":
  RUN `analyze-existing-diagrams`
RUN `build-diagram`
RUN `write-diagram`
RETURN: format="EXCALIDRAW_FILE_V1", excalidraw_json=EXCALIDRAW_JSON
</process>

<process id="parse-diagram-request" name="Parse diagram request">
SET DIAGRAM_DESCRIPTION := <DESCRIPTION> (from "Agent Inference" using USER_INPUT)
SET OUTPUT_PATH := <PATH> (from "Agent Inference" using USER_INPUT)
</process>

<process id="analyze-existing-diagrams" name="Analyze existing diagrams">
USE `Glob` where: path=".", pattern="**/*.excalidraw"
CAPTURE EXISTING_FILES from `Glob`
FOREACH file IN EXISTING_FILES:
  USE `Read` where: path=file
  CAPTURE FILE_CONTENT from `Read`
SET STYLE_PATTERNS := <PATTERNS> (from "Agent Inference" using FILE_CONTENT)
</process>

<process id="build-diagram" name="Build diagram JSON">
SET LAYOUT_TYPE := <TYPE> (from "Agent Inference" using DIAGRAM_DESCRIPTION)
SET REQUIRED_ELEMENTS := <ELEMENTS> (from "Agent Inference" using DIAGRAM_DESCRIPTION)
SET RELATIONSHIPS := <RELATIONSHIPS> (from "Agent Inference" using DIAGRAM_DESCRIPTION)
SET ELEMENTS := <BUILT_ELEMENTS> (from "Agent Inference" using DEFAULT_BACKGROUND, DEFAULT_GRID_SIZE, DEFAULT_VERSION, LAYOUT_TYPE, MIN_ELEMENT_GAP, RELATIONSHIPS, REQUIRED_ELEMENTS, STYLE_PATTERNS)
SET EXCALIDRAW_JSON := <JSON> (from "Agent Inference" using ELEMENTS)
</process>

<process id="write-diagram" name="Write diagram when requested">
IF OUTPUT_PATH is not empty:
  USE `Write` where: content=EXCALIDRAW_JSON, path=OUTPUT_PATH
</process>
</processes>

<input>
USER_INPUT is the desired diagram description and optional output path.
</input>
