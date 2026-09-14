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
  type: "Projektbericht",
  title: "Report: Tangible Interface Desk",
  subtitle: "Interactive Ubiquitous Systems and Intelligent User Interfaces",
  authors: ((
    name: "Georg Forberger, Jason Dippmann, Marvin Menzel, Ben Weckend",
    studentID: "...",
  ),),
  supervisors: ((
    title: "Dr.",
    name: "Akshay Deshmukh",
  ),),
  examiners: ((
    title: "Dr.",
    name: "Akshay Deshmukh",
  ),),
  lang: "de",
  extra_outlines: (table_of_symbols,),
  //references: "references.bib"
)

#set heading(numbering: none)

== Introduction
Ubiquitous computing shifts computation away from a single desktop and embeds it in everyday environments and activities @weiser1991. Museums are a particularly suitable context for this idea: visitors already move through physical space, handle or observe material artefacts, and often explore in social groups. However, conventional exhibitions frequently organize companies, technologies, and products as separate exhibits. This structure is easy to curate but poorly suited to explaining an industrial ecosystem. The essential relationships - material supply, sensing, data processing, automation, energy, and production - are processes rather than isolated objects.

The project addresses this communication problem for an exhibition context in Freiberg and Saxony. Its concept is a tangible interface table on which visitors place and combine blocks. Each block represents either an industrial role or a regional company. A camera above the table should identify type and position, while a projector should augment the surface with animated connections, process labels, and contextual information. This coupling of graspable objects and digital representations follows the core idea of Tangible Bits: digital information becomes directly manipulable through physical artefacts @ishii1997. The installation is intended for a broad audience including museum visitors, families, tourists, school groups, students, and people interested in technology.

The intended final installation requires calibrated sensing, projection, robust physical tokens, and museum access. Building all components before testing the information and interaction design would be costly. We therefore created a browser-based two-dimensional prototype that reproduces the central interaction loop with virtual blocks. It asks a practical design question: *Can a direct manipulation prototype make the relationships within a regional industrial network visible while remaining simple enough for self-directed museum exploration?*

This report contributes a translation of the tangible table concept into explicit interaction and information requirements, an implemented web prototype covering ten industrial actors and seventeen relationships, and a formative evaluation that separates verified prototype behavior from claims that still require user research. The result is not a finished museum exhibit. It is an executable design hypothesis that allows the team and domain experts to inspect the content model, interaction flow, and technical risks before committing to the physical system.

== Related Work
Ishii and Ullmer define tangible user interfaces as a way to bridge bits and atoms by coupling digital information with graspable objects and architectural surfaces @ishii1997. Their work provides the conceptual foundation for representing industrial actors as blocks and for projecting otherwise invisible relations onto a table. Hornecker and Buur broaden this perspective by describing tangible interaction through tangible manipulation, spatial interaction, embodied facilitation, and expressive representation @hornecker2006. These themes are relevant to a public tabletop: visitors should understand what can be moved, be able to arrange objects within a shared space, see each other's actions, and receive legible feedback about the meaning of a configuration.

Research in informal learning suggests that physical interaction should not be treated as automatically superior to a graphical interface. Horn et al. compared tangible and graphical programming interfaces in a museum context. Both were understandable, but the tangible version was more inviting, supported active collaboration, and shifted activity toward children @horn2009. This motivates the physical direction of our installation while also reinforcing the need for comparative, observational evaluation rather than assuming an educational effect.

Interactive tabletops have also been applied directly to museum collections. Ciocca, Olivo, and Schettini presented a multi-touch tabletop that combines touch gestures with recognized physical objects for image browsing. Their study with sixteen participants reported broad interest and demonstrated the value of serving both individual and collaborative exploration @ciocca2012. Our project transfers this mixed interaction pattern from image retrieval to an industrial network: the primary information object is not a picture but a company node whose meaning emerges through links to other nodes.

The present work differs from these systems in two ways. First, it focuses on regional industrial value creation, where relationships and dependencies are the main educational content. Second, it deliberately begins with a web prototype. This abstraction cannot evaluate the tactile quality or social arrangement of physical tokens, but it can expose issues in the data model, visual hierarchy, and interaction state before hardware construction.


== Methodology
=== Design Process and Requirements
The team followed an iterative, evolutionary prototype-led process. Initial concept pitches identified the exhibition problem, the table-camera-projector setup, and the motto "From raw material to connected industry." A later research plan defined expert interviews (museum staff) as the appropriate first evaluation phase because experts can assess an early representation and validate the overall approach. Observation and visitor interviews were reserved for a more mature version. This sequencing avoids asking museum visitors to compensate for technical incompleteness while still creating a path toward empirical evaluation.

The concept and target groups were translated into five design requirements:

- *Direct manipulation:* adding, moving, selecting, and removing a node should use spatial gestures rather than menus.
- *Immediate relational feedback:* a valid pair should reveal its relationship without a separate command.
- *Progressive disclosure:* the overview should remain readable, while details about a company, its products, and active partners appear on demand.
- *Multi-input readiness:* the same interaction path should support mouse, touch, and pen and provide a software boundary for later camera or TUIO input.
- *Regional grounding:* the prototype should connect abstract industrial roles to companies and locations in Saxony.

=== Content Model
The implementation models ten actors: Bergbau Sachsen, GEMAC Chemnitz, FlowLogiX, XENON, Sunfire, i2S Dresden, 3D-Micromac, Kontron AIS, WESOBA, and Siemens Energy. Each actor has an identifier, display name, industrial role, short description, products or technologies, logo path, color, and optionally geographic coordinates. A separate relation list defines seventeen undirected links such as sensor data, diagnostics data, production optimization, automation, sustainable production, and energy infrastructure.

This explicit graph is deliberately small enough to inspect manually. It captures a narrative path from raw materials through sensing and data processing to automation and energy. At the same time, the labels should be understood as exhibition content authored for the prototype, not as a verified representation of commercial contracts. Domain review is therefore required before public deployment.

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

== Implementation

#align(center)[
  #link("https://ubiquitous-systems.github.io/Ubiquitous-Systems-Project/Prototyp/main.html")[#emph[Prototype Link for Direct Interaction hosted on GitHub Pages]]
  ]


=== User Interface Architecture
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


=== Interaction and State Management
The runtime state consists of a list of placed nodes and a map of active pointers. Pointer Events unify mouse, touch, and pen input. When a user presses a company block, the system creates a visual drag ghost. Releasing outside the sidebar calls a central `placeNode` function, removes the source block from the catalogue, adds a node at the pointer coordinates, updates company details, optionally adds a map marker, and redraws the canvas. This central function is also the intended integration point for future camera or TUIO recognition: recognized object identifiers and coordinates can enter the same state transition without duplicating presentation logic.

Placed nodes can be moved independently. The `activePointers` map stores pointer identifier, mode, start position, offset, and movement state, so several contacts can be tracked concurrently. A ten-pixel threshold distinguishes a tap from a drag. A tap opens company details; dragging a node back over the sidebar removes it and restores its original block. Although the code is multi-pointer-ready, genuine simultaneous multi-user interaction still needs to be tested on the target table hardware.

After every state change, the canvas is cleared and redrawn. For each relation, the renderer searches for both endpoint types in the node list. If both are present, it draws an animated gradient line and the relation label. Selecting a node filters the same relation list to present only active partners in the information panel. This shared data source keeps the graphical overview and textual detail consistent.

=== System Status and Geographic Context
The completion indicator uses a rule-based checkpoint. A configuration is considered active when it contains five designated roles represented by Bergbau Sachsen, GEMAC, FlowLogiX, XENON, and Sunfire. The badge then changes from a red warning to a green confirmation and can display a concise explanation of the ecosystem. This is effective as formative feedback, but the rule currently checks membership rather than actual graph connectivity or alternative valid value chains.

MapLibre GL JS renders OpenStreetMap raster tiles. The museum is represented by a fixed red reference marker; companies with coordinates are added or removed with their nodes, after which the viewport fits all current markers. Only three company records currently contain coordinates, so the map is a partial proof of concept. Both the MapLibre library and map tiles are loaded from external services, which makes the current prototype dependent on network access.

#figure(
  image("/assets/Bildschirmfoto vom 2026-09-14 10-37-59.png"),
  caption: [Map view with company markers.],
) <prototype-map>

== Evaluation
=== Evaluation Approach
The prototype was evaluated in two small formative sessions. The aim was not to demonstrate a measurable learning effect, but to identify usability and communication problems. The evaluation focused on five questions: whether participants understood the purpose of the system, whether the interaction was discoverable and intuitive, whether the amount and presentation of information were appropriate, whether the installation appeared suitable for a museum, and which changes should be prioritized in the next iteration.

Participants interacted with the prototype individually. In the first session, the expert participant (museum staff) received no introduction so that initial discoverability could be observed. The interaction was followed by a short semi-structured interview covering system understanding, ease of use, missing elements, an appropriate interaction duration, suitability for the museum context, and an overall rating on a scale from 1 to 10. A second session was conducted with a student using the final web prototype and addressed the same general topics. The available records contain qualitative observations, improvement suggestions, and one rating for each session, but no standardized task-completion times or error counts.

Participation was voluntary and could be stopped at any time. The consent form permitted the use of anonymized statements and optional audio recordings for teaching and research within the project. No personal information is reported here. Because the purpose of the evaluation was formative and the sample was very small, the results were analyzed descriptively. Recurring observations and individual suggestions were grouped into the themes interaction, information presentation, and museum suitability.

=== Findings
Both participants recognized the basic purpose of the prototype: placing companies on the surface reveals their roles and relationships within a regional industrial network. The direct-manipulation concept was generally perceived as simple and understandable. In the first session, however, the participant initially hesitated because no explicit instruction or idle animation indicated what to do. After a short period of exploration, understanding increased substantially. In the second session, the tutorial was explicitly described as supporting intuitive use. Together, these observations suggest that the interaction itself is easy to learn once the first action has been communicated.

The visualized relations were central to understanding the system. The second participant reported obtaining the main information from the connection descriptions, which confirms the importance of edge labels in the current design. At the same time, the direction of a connection was not always evident. The participant therefore suggested making the flow direction more visible. This is particularly relevant because the project explains processes and dependencies rather than merely indicating that two companies are associated.

The amount of content was judged positively. The first interview described the number of companies as appropriate and the interface as not overloaded. The participant emphasized that a museum station should remain concise and proposed optional details on demand instead of permanently displaying more text. A company location map and contextual company information were also requested. The second participant similarly asked for more information about individual companies, as well as a different typeface and larger text. These comments support the current progressive-disclosure approach but show that readability and the depth of the detail view still require refinement.

Both responses indicated that the concept could fit a museum setting and appeal to different age groups. The multimedia format was considered attractive to younger visitors, while the simple interaction was expected to remain accessible to older visitors if lightweight guidance is available. One interview suggested approximately five minutes as a suitable interaction period for the station, without imposing a fixed time limit. The two overall ratings were 9/10 and 8/10, corresponding to a descriptive mean of 8.5/10. Given the sample size, this value should be interpreted only as positive formative feedback, not as a generalizable usability score.


== Discussion
The evaluation provides initial support for the central design hypothesis. Participants were able to infer that companies can be combined to expose an industrial network, and the direct manipulation was rated as easy after the first interaction had been discovered. This is encouraging for a self-directed exhibition, where visitors should not depend on continuous staff assistance. The findings nevertheless distinguish learnability from discoverability: an interaction can be simple once known while still lacking a sufficiently clear invitation to begin.

The feedback also shows that the prototype's educational value currently depends heavily on the presentation of relationships. Company nodes establish the actors, but the connection descriptions explain why a configuration matters. Their reported importance validates the decision to label edges semantically. However, an undirected line can blur differences between material supply, measurement, control, and energy flow. Without visible direction or a small explanatory legend, visitors may recognize that companies are connected while forming an incomplete interpretation of the underlying process.

Requests for both concise presentation and additional company information are not contradictory. They indicate a need for progressive disclosure: the shared table view should provide a quickly readable overview, while selection should reveal optional details for visitors who wish to explore further. The map follows the same principle by linking the abstract network to the regional context without adding information to every node. The prototype therefore has an appropriate structural basis, but content density, typography, and the transition between overview and detail should be tuned on the target display.

Finally, the evaluation concerns a browser representation of a tangible installation. It validates parts of the content hierarchy and interaction logic, but not the complete embodied experience. Physical blocks may make the first action more inviting and support collaboration, yet they also introduce recognition errors, occlusion, calibration issues, and competition for table space. These aspects can only be assessed with the camera-projector setup in the intended spatial context.


=== Design Implications
The findings lead to six concrete implications for the next design iteration:

- *Communicate the first action:* A short, non-blocking tutorial or idle animation should demonstrate dragging or placing one block. It should disappear after interaction and remain available on demand so that returning visitors are not delayed. (Implemented)
- *Encode relation direction:* Connections should use arrowheads, moving particles, or another redundant directional cue in addition to animation and text. Labels should distinguish material, data, control, and energy flows where this difference is meaningful.
- *Preserve progressive disclosure:* The overview should remain concise. Selecting a company should reveal optional information about its role, products, active partners, and location without obscuring the shared workspace. (Implemented)
- *Improve legibility and accessibility:* Type size, typeface, contrast, label placement, and touch-target size should be tested on the actual projection surface and at typical viewing distances. Instructions should not rely on motion or color alone.
- *Complete and review the content model:* Geographic data should be added consistently, and company descriptions and relations should be reviewed with museum and domain experts. The completion indicator should test graph connectivity or valid process paths instead of only the presence of five fixed companies.
- *Prepare for shared physical use:* The next prototype should test simultaneous interactions, accidental placements, object removal, projection occlusion, and recovery from recognition errors. Feedback should remain understandable when several visitors act at the same time.


== Conclusion and Future Work
This project translated the concept of a tangible museum table into a functional web prototype for exploring relationships among industrial actors in Saxony. The implementation demonstrates the complete interaction loop at interface level: visitors can place and move company nodes, reveal labeled relationships, inspect contextual details, view available locations, and receive feedback about a larger ecosystem configuration. Separating the company graph from the interaction logic also creates a practical integration point for future camera or TUIO input.

The two formative sessions indicate that the core concept is understandable and promising for a museum context. Participants rated the prototype 9/10 and 8/10 and described the interaction as simple once the initial action was clear. The evaluation also identified specific weaknesses: first-use guidance is necessary, connection direction should be explicit, company information and location context should be available on demand, and typography must be optimized for the exhibition setting. These results are design guidance rather than evidence of broad usability or learning effectiveness.

The immediate next step is to revise the web prototype by adding directional and categorized relations and improved typography. In parallel, the team should review all company descriptions and links with museum and industry experts. The revised interface can then be transferred to a physical table with robust tangible markers, calibrated camera recognition, projection mapping, and offline-capable assets.

Future evaluation should involve a larger and more diverse sample in a museum-like environment. Participants should complete representative exploration tasks while the study records time to first meaningful action, task completion, errors, requests for help, interaction duration, and collaboration patterns. Short interviews and a standardized usability measure can complement these observations. A later comparison between graphical and tangible versions would help determine which benefits arise from the information design and which arise specifically from physical interaction.


== Acknowledgements

We thank Dr. Akshay Deshmukh for guidance within the course *Interactive Ubiquitous Systems and Intelligent User Interfaces*. Map data in the prototype is provided by OpenStreetMap contributors.


#pagebreak()
#bibliography("references.bib", style: "association-for-computing-machinery")
