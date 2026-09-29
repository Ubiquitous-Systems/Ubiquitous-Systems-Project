#import "tubaf_template.typ" as tubaf

// function for table of symbols and acronyms
#let table_of_symbols() = {
  show outline: set heading(outlined: true)
  outline(
    title: "Symbol- und Abkürzungsverzeichnis",
    target: figure.where(caption: "-")
  )

  text()[*Formelzeichen*]
  grid(
    columns: (1fr, 1cm, 8fr),
    gutter: .5em,
    $bb(Z)$, "", [Menge der ganzen Zahlen],
    $bb(R)$, "", [Menge der reellen Zahlen],
  )

  linebreak()
  text()[*Abkürzungen*]
  grid(
    columns: (1fr, 1cm, 8fr),
    gutter: .5em,
    "Cobot", "", [kollaborativer Roboter],
  )
}


// report template
#show: tubaf.report.with(
  type: "Project Report",
  title: "Report: Tangible Interface Desk",
  subtitle: "Interactive Ubiquitous Systems and Intelligent User Interfaces",
  authors: ((
    name: "Jason Dippmann, Georg Forberger, Marvin Menzel, Ben Weckend",
    studentID: "66719, 66858, 66642, 67551",
  ),),
  supervisors: ((
    title: "Dr.",
    name: "Akshay Deshmukh",
  ),),
  examiners: ((
    title: "Dr.",
    name: "Akshay Deshmukh",
  ),),
  lang: "en",
  // extra_outlines: (table_of_symbols,),
  //references: "references.bib"
)

#set heading(numbering: "1.1")

= Introduction
Ubiquitous computing shifts computation away from a single desktop and embeds it in everyday environments and activities @weiser1991. Museums are a particularly suitable context for this idea: visitors already move through physical space, handle or observe material artefacts, and often explore in social groups. However, conventional exhibitions frequently organize companies, technologies, and products as separate exhibits. This structure is easy to curate but poorly suited to explaining an industrial ecosystem. Important connections such as material supply, sensing, data processing, automation, energy, diffentent products and production are difficult to communicate through isolated exhibits.

The project addresses this communication problem for an exhibition context in Freiberg and Saxony. Its concept is a tangible interface table on which visitors place and combine blocks. Each block represents either an industrial role or a regional company. A camera above the table should identify its type and position, while a projector should augment the surface with animated connections, process labels, and contextual information. This combination of physical objects and digital information follows the core idea of tangible interfaces, where digital information can be manipulated through physical artefacts @ishii1997. The installation is intended for a diverse audience including museum visitors, families, tourists, school groups, students, and people interested in technology.

The intended installation requires calibrated sensing, projection, robust physical tokens, and museum access. Building all components before testing the information and interaction design would be costly. We therefore created a browser-based two-dimensional prototype that reproduces the central interaction loop with virtual blocks. It addresses the following practical design question: Can a direct manipulation prototype make the relationships within a regional industrial network visible while remaining simple enough for self-directed museum exploration?

This report describes the design requirements derived from the tangible table concept, the implementation of a web prototype with ten industrial actors and seventeen relationships, and a small formative evaluation. The prototype is not a finished museum exhibit, but it provides a way to test the content structure, interaction flow, and visual presentation before developing a possible physical version.

= Related Work

Research on tangible user interfaces describes the idea of connecting digital information with physical objects that users can directly manipulate @ishii1997. This concept is relevant to our project because the planned installation represents companies and industrial roles as physical blocks on a table. Their placement can then be extended with projected information, such as connections, process descriptions, and additional context.

Work on tangible interaction also emphasizes physical manipulation, spatial arrangement, shared interaction spaces, and clear feedback @hornecker2006. These aspects are especially relevant for an interactive museum table, where visitors should be able to understand which objects can be moved, arrange them freely, and immediately see how their actions change the displayed information.

Our project applies these ideas to the visualization of a regional industrial network. Instead of presenting companies and technologies as isolated elements, the main focus is on showing the relationships between them. The system is therefore designed around placing and combining company nodes and revealing the corresponding material, data, automation, or energy connections.

Before implementing a complete camera-projector setup with physical blocks, the project used a browser-based prototype to test the main interaction and information design. The prototype cannot reproduce the physical experience of the intended installation, but it allows the team to examine the network structure, visual presentation, and interaction flow without requiring the full hardware setup.


= Methodology

This chapter describes how the initial concept was translated into a working prototype. It outlines the main design requirements and explains how companies and their relationships are represented in the system. The goal was to create a manageable prototype that could be tested before implementing the full physical table setup.

== Design Approach and Requirements

The project followed an iterative, prototype driven design process. Early concept work defined the exhibition problem, the table-camera-projector setup, and the guiding theme “From raw material to connected industry.” Since the complete physical installation was too complex to implement at this stage, we developed a browser-based prototype that focused on the core interaction and information design.

For the first evaluation stage, feedback from museum staff was chosen to assess whether the concept, interaction, and presentation were suitable for an exhibition context. Visitor observations and interviews were planned for a later stage, when a more refined version of the installation is available. This allowed us to gather useful feedback without requiring the camera tracking, projection, and physical objects to be fully implemented.

Based on the concept and intended target groups, five main design requirements were defined:

- Direct manipulation: Users should be able to add, move, select, and remove nodes directly on the surface instead of using menus.
- Immediate relational feedback: When two connected companies are placed on the surface, their relationship should appear automatically.
- Progressive disclosure: The network overview should remain simple and readable, while additional information about companies, products, and active connections can be shown on demand.
- Multi-input readiness: The same basic interactions should work with mouse, touch, and pen input and allow later integration of camera-based input.
- Regional grounding: The prototype should connect industrial roles and processes with companies and locations in Saxony.

== Content Model

The prototype represents ten industrial actors: Bergbau Sachsen, GEMAC Chemnitz, FlowLogiX, XENON, Sunfire, i2S Dresden, 3D-Micromac, Kontron AIS, WESOBA, and Siemens Energy. Each actor is represented as a structured data object containing an identifier, display name, industrial role, short description, associated products or technologies, logo path, visual color, and, where available, geographic coordinates.

Relationships between actors are stored separately as an explicit graph consisting of seventeen directed links. These links describe thematic or functional relationships such as sensor data exchange, diagnostics data, production optimization, automation, sustainable production, and energy infrastructure.

The graph was intentionally kept small enough to remain transparent and manually inspectable during prototype development. Its structure supports an exhibition narrative that progresses from raw materials through sensing and data processing to automation, production, and energy infrastructure.

The relationships and labels should, however, be understood as exhibition content developed for the prototype rather than as verified representations of existing commercial partnerships or contractual relationships. A domain and content review would therefore be required before the system could be deployed in a public exhibition.

#let accent = rgb("#2563EB")
#let card-fill = rgb("#F3F6FA")
#let card-stroke = rgb("#D7DEE8")
#let arrow-color = rgb("#7A8699")

#let pipeline-step(title) = block(
  width: 100%,
  inset: (x: 10pt, y: 9pt),
  radius: 5pt,
  fill: card-fill,
  stroke: 0.6pt + card-stroke,
  align(center)[
    #text(
      size: 9pt,
      weight: "semibold",
      fill: rgb("#1F2937"),
    )[#title]
  ],
)

#let pipeline-arrow = text(
  size: 14pt,
  weight: "light",
  fill: arrow-color,
)[→]

#figure(
  align(
    center,
    grid(
      columns: (
        1.25fr, auto,
        1.25fr, auto,
        1.25fr, auto,
        1.25fr, auto,
        1.6fr,
      ),
      column-gutter: 7pt,
      align: center + horizon,

      pipeline-step[Raw materials],
      pipeline-arrow,

      pipeline-step[Sensing],
      pipeline-arrow,

      pipeline-step[Edge / AI],
      pipeline-arrow,

      pipeline-step[Automation],
      pipeline-arrow,

      pipeline-step[Energy & production],
    ),
  ),

  caption: [
    Simplified narrative path represented by the prototype's company graph.
    The interface permits non-linear combinations; the path is an explanatory abstraction.
  ],
) <fig-pipeline>

= Implementation

#align(center)[
  #link("https://ubiquitous-systems.github.io/Ubiquitous-Systems-Project/Prototyp/main.html")[#emph[Prototype Link for Direct Interaction hosted on GitHub Pages]]
  ]


== User Interface Architecture
The prototype is implemented without an application framework using HTML, CSS, and JavaScript. The screen is divided into four layers. A left sidebar acts as the source catalogue of company blocks. A full-window HTML canvas represents the table surface and draws placed nodes, a subtle grid, connection lines, and labels. A right information panel shows the selected company's logo, role, description, products, and currently active partners. A MapLibre map provides geographic context, and a status badge near the lower edge summarizes whether the designated ecosystem is complete.

#figure(
  image("/assets/Bildschirmfoto vom 2026-09-14 10-35-59.png"),
  caption: [Left sidebar with company catalogue.],
) <left-sidebar>


Visual design uses a dark radial background and translucent panels so that saturated node colors and animated connections remain prominent. Each company has a stable color used for its catalogue marker, canvas node, connection gradient, and information heading. Connections are rendered as dashed lines whose offset changes in an animation loop. This motion indicates flow and makes otherwise static graph edges perceptually salient. Text labels at the edge midpoint explain the semantic relation rather than relying on color or proximity alone.

#figure(
  image("/assets/image.png"),
  caption: [Prototype interface preview.],
) <prototype-preview>


== Interaction and State Management
The runtime state consists of a list of placed nodes and a map of active pointers. Pointer Events unify mouse, touch, and pen input. When a user presses a company block, the system creates a visual drag ghost. Releasing outside the sidebar calls a central `placeNode` function, removes the source block from the catalogue, adds a node at the pointer coordinates, updates company details, optionally adds a map marker, and redraws the canvas. This central function is also the intended integration point for future camera or TUIO recognition: recognized object identifiers and coordinates can enter the same state transition without duplicating presentation logic.

Placed nodes can be moved independently. The `activePointers` map stores pointer identifier, mode, start position, offset, and movement state, so several contacts can be tracked concurrently. A ten-pixel threshold distinguishes a tap from a drag. A tap opens company details; dragging a node back over the sidebar removes it and restores its original block. Although the code is multi-pointer-ready, genuine simultaneous multi-user interaction still needs to be tested on the target table hardware.

After every state change, the canvas is cleared and redrawn. For each relation, the renderer searches for both endpoint types in the node list. If both are present, it draws an animated gradient line and the relation label. Selecting a node filters the same relation list to present only active partners in the information panel. This shared data source keeps the graphical overview and textual detail consistent.

== System Status and Geographic Context
The completion indicator uses a rule-based checkpoint. A configuration is considered active when it contains five designated roles represented by Bergbau Sachsen, GEMAC, FlowLogiX, XENON, and Sunfire. The badge then changes from a red warning to a green confirmation and can display a concise explanation of the ecosystem. This is effective as formative feedback, but the rule currently checks membership rather than actual graph connectivity or alternative valid value chains.

MapLibre GL JS renders OpenStreetMap raster tiles. The museum is represented by a fixed red reference marker; companies with coordinates are added or removed with their nodes, after which the viewport fits all current markers. Only three company records currently contain coordinates, so the map is a partial proof of concept. Both the MapLibre library and map tiles are loaded from external services, which makes the current prototype dependent on network access.

#figure(
  image("/assets/Bildschirmfoto vom 2026-09-14 10-37-59.png"),
  caption: [Map view with company markers.],
) <prototype-map>

= Evaluation
== Evaluation Approach
The prototype was evaluated in two small formative sessions. The aim was not to demonstrate a measurable learning effect, but to identify usability and communication problems. The evaluation focused on five questions: whether participants understood the purpose of the system, whether the interaction was discoverable and intuitive, whether the amount and presentation of information were appropriate, whether the installation appeared suitable for a museum, and which changes should be prioritized in the next iteration.

Participants interacted with the prototype individually. In the first session, the expert participant (museum staff) received no introduction so that initial discoverability could be observed. The interaction was followed by a short semi-structured interview covering system understanding, ease of use, missing elements, an appropriate interaction duration, suitability for the museum context, and an overall rating on a scale from 1 to 10. A second session was conducted with a student using the final web prototype and addressed the same general topics. The available records contain qualitative observations, improvement suggestions, and one rating for each session, but no standardized task-completion times or error counts.

Participation was voluntary and could be stopped at any time. The consent form permitted the use of anonymized statements and optional audio recordings for teaching and research within the project. No personal information is reported here. Because the purpose of the evaluation was formative and the sample was very small, the results were analyzed descriptively. Recurring observations and individual suggestions were grouped into the themes interaction, information presentation, and museum suitability.

== Findings
Both participants recognized the basic purpose of the prototype: placing companies on the surface reveals their roles and relationships within a regional industrial network. The direct-manipulation concept was generally perceived as simple and understandable. In the first session, however, the participant initially hesitated because no explicit instruction or idle animation indicated what to do. After a short period of exploration, understanding increased substantially. In the second session, the tutorial was explicitly described as supporting intuitive use. Together, these observations suggest that the interaction itself is easy to learn once the first action has been communicated.

The visualized relations were central to understanding the system. The second participant reported obtaining the main information from the connection descriptions, which confirms the importance of edge labels in the current design. At the same time, the direction of a connection was not always evident. The participant therefore suggested making the flow direction more visible. This is particularly relevant because the project explains processes and dependencies rather than merely indicating that two companies are associated.

The amount of content was judged positively. The first interview described the number of companies as appropriate and the interface as not overloaded. The participant emphasized that a museum station should remain concise and proposed optional details on demand instead of permanently displaying more text. A company location map and contextual company information were also requested. The second participant similarly asked for more information about individual companies, as well as a different typeface and larger text. These comments support the current progressive-disclosure approach but show that readability and the depth of the detail view still require refinement.

Both responses indicated that the concept could fit a museum setting and appeal to different age groups. The multimedia format was considered attractive to younger visitors, while the simple interaction was expected to remain accessible to older visitors if lightweight guidance is available. One interview suggested approximately five minutes as a suitable interaction period for the station, without imposing a fixed time limit. The two overall ratings were 9/10 and 8/10, corresponding to a descriptive mean of 8.5/10. Given the sample size, this value should be interpreted only as positive formative feedback, not as a generalizable usability score.


= Discussion
The evaluation provides initial support for the central design hypothesis. Participants were able to infer that companies can be combined to expose an industrial network, and the direct manipulation was rated as easy after the first interaction had been discovered. This is encouraging for a self-directed exhibition, where visitors should not depend on continuous staff assistance. The findings nevertheless distinguish learnability from discoverability: an interaction can be simple once known while still lacking a sufficiently clear invitation to begin.

The feedback also shows that the prototype's educational value currently depends heavily on the presentation of relationships. Company nodes establish the actors, but the connection descriptions explain why a configuration matters. Their reported importance validates the decision to label edges semantically. However, an undirected line can blur differences between material supply, measurement, control, and energy flow. Without visible direction or a small explanatory legend, visitors may recognize that companies are connected while forming an incomplete interpretation of the underlying process.

Requests for both concise presentation and additional company information are not contradictory. They indicate a need for progressive disclosure: the shared table view should provide a quickly readable overview, while selection should reveal optional details for visitors who wish to explore further. The map follows the same principle by linking the abstract network to the regional context without adding information to every node. The prototype therefore has an appropriate structural basis, but content density, typography, and the transition between overview and detail should be tuned on the target display.

Finally, the evaluation concerns a browser representation of a tangible installation. It validates parts of the content hierarchy and interaction logic, but not the complete embodied experience. Physical blocks may make the first action more inviting and support collaboration, yet they also introduce recognition errors, occlusion, calibration issues, and competition for table space. These aspects can only be assessed with the camera-projector setup in the intended spatial context.


== Design Implications
The findings lead to six concrete implications for the next design iteration:

- *Communicate the first action:* A short, non-blocking tutorial or idle animation should demonstrate dragging or placing one block. It should disappear after interaction and remain available on demand so that returning visitors are not delayed. (Implemented)
- *Encode relation direction:* Connections should use arrowheads, moving particles, or another redundant directional cue in addition to animation and text. Labels should distinguish material, data, control, and energy flows where this difference is meaningful.
- *Preserve progressive disclosure:* The overview should remain concise. Selecting a company should reveal optional information about its role, products, active partners, and location without obscuring the shared workspace. (Implemented)
- *Improve legibility and accessibility:* Type size, typeface, contrast, label placement, and touch-target size should be tested on the actual projection surface and at typical viewing distances. Instructions should not rely on motion or color alone.
- *Complete and review the content model:* Geographic data should be added consistently, and company descriptions and relations should be reviewed with museum and domain experts. The completion indicator should test graph connectivity or valid process paths instead of only the presence of five fixed companies.
- *Prepare for shared physical use:* The next prototype should test simultaneous interactions, accidental placements, object removal, projection occlusion, and recovery from recognition errors. Feedback should remain understandable when several visitors act at the same time.


= Conclusion and Future Work
This project translated the concept of a tangible museum table into a functional web prototype for exploring relationships among industrial actors in Saxony. The implementation demonstrates the complete interaction loop at interface level: visitors can place and move company nodes, reveal labeled relationships, inspect contextual details, view available locations, and receive feedback about a larger ecosystem configuration. Separating the company graph from the interaction logic also creates a practical integration point for future camera or TUIO input.

The two formative sessions indicate that the core concept is understandable and promising for a museum context. Participants rated the prototype 9/10 and 8/10 and described the interaction as simple once the initial action was clear. The evaluation also identified specific weaknesses: first-use guidance is necessary, connection direction should be explicit, company information and location context should be available on demand, and typography must be optimized for the exhibition setting. These results are design guidance rather than evidence of broad usability or learning effectiveness.

The immediate next step is to revise the web prototype by adding directional and categorized relations and improved typography. In parallel, the team should review all company descriptions and links with museum and industry experts. The revised interface can then be transferred to a physical table with robust tangible markers, calibrated camera recognition, projection mapping, and offline-capable assets.

Future evaluation should involve a larger and more diverse sample in a museum-like environment. Participants should complete representative exploration tasks while the study records time to first meaningful action, task completion, errors, requests for help, interaction duration, and collaboration patterns. Short interviews and a standardized usability measure can complement these observations. A later comparison between graphical and tangible versions would help determine which benefits arise from the information design and which arise specifically from physical interaction.


= Acknowledgements

We thank Dr. Akshay Deshmukh for guidance within the course *Interactive Ubiquitous Systems and Intelligent User Interfaces*. Map data in the prototype is provided by OpenStreetMap contributors.


#pagebreak()
#bibliography("references.bib", style: "association-for-computing-machinery")
