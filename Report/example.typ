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
=== User Interface Architecture
The prototype is implemented without an application framework using HTML, CSS, and JavaScript. The screen is divided into four layers. A left sidebar acts as the source catalogue of company blocks. A full-window HTML canvas represents the table surface and draws placed nodes, a subtle grid, connection lines, and labels. A right information panel shows the selected company's logo, role, description, products, and currently active partners. A MapLibre map provides geographic context, and a status badge near the lower edge summarizes whether the designated ecosystem is complete.

Visual design uses a dark radial background and translucent panels so that saturated node colors and animated connections remain prominent. Each company has a stable color used for its catalogue marker, canvas node, connection gradient, and information heading. Connections are rendered as dashed lines whose offset changes in an animation loop. This motion indicates flow and makes otherwise static graph edges perceptually salient. Text labels at the edge midpoint explain the semantic relation rather than relying on color or proximity alone.

#figure(
  image("/assets/image.png"),
  caption: [Prototype interface preview.],
) <mein-bild>


=== Interaction and State Management
The runtime state consists of a list of placed nodes and a map of active pointers. Pointer Events unify mouse, touch, and pen input. When a user presses a company block, the system creates a visual drag ghost. Releasing outside the sidebar calls a central `placeNode` function, removes the source block from the catalogue, adds a node at the pointer coordinates, updates company details, optionally adds a map marker, and redraws the canvas. This central function is also the intended integration point for future camera or TUIO recognition: recognized object identifiers and coordinates can enter the same state transition without duplicating presentation logic.

Placed nodes can be moved independently. The `activePointers` map stores pointer identifier, mode, start position, offset, and movement state, so several contacts can be tracked concurrently. A ten-pixel threshold distinguishes a tap from a drag. A tap opens company details; dragging a node back over the sidebar removes it and restores its original block. Although the code is multi-pointer-ready, genuine simultaneous multi-user interaction still needs to be tested on the target table hardware.

After every state change, the canvas is cleared and redrawn. For each relation, the renderer searches for both endpoint types in the node list. If both are present, it draws an animated gradient line and the relation label. Selecting a node filters the same relation list to present only active partners in the information panel. This shared data source keeps the graphical overview and textual detail consistent.

=== System Status and Geographic Context
The completion indicator uses a rule-based checkpoint. A configuration is considered active when it contains five designated roles represented by Bergbau Sachsen, GEMAC, FlowLogiX, XENON, and Sunfire. The badge then changes from a red warning to a green confirmation and can display a concise explanation of the ecosystem. This is effective as formative feedback, but the rule currently checks membership rather than actual graph connectivity or alternative valid value chains.

MapLibre GL JS renders OpenStreetMap raster tiles. The museum is represented by a fixed red reference marker; companies with coordinates are added or removed with their nodes, after which the viewport fits all current markers. Only three company records currently contain coordinates, so the map is a partial proof of concept. Both the MapLibre library and map tiles are loaded from external services, which makes the current prototype dependent on network access.

== Evaluation
=== Evaluation Approach
No completed participant study or quantitative dataset is included in the project material. We therefore conducted a formative evaluation consisting of source inspection, a desktop browser smoke test, and scenario-based reasoning against the stated requirements. The smoke test checked initial rendering, content availability, console behavior, and external dependencies. Source inspection traced the state transitions for adding, moving, selecting, connecting, and removing nodes. This method can identify implementation gaps and testability risks, but it cannot establish usability, engagement, learning, or museum suitability.

#figure(
  table(
    columns: (22%, 28%, 1fr),
    inset: 5pt,
    stroke: 0.4pt + gray,
    fill: (x, y) => if y == 0 { blue } else { none },
    table.header([*Scenario*], [*Evidence inspected*], [*Formative result*]),
    [Initial orientation], [Desktop browser smoke test], [The title, instruction, ten company blocks, information panel, map area, and incomplete-network badge establish the starting state.],
    [Build a network], [Pointer handlers and relation renderer], [The implementation supports placement and movement and reveals an edge only when both endpoints are present. Seventeen relations are available.],
    [Inspect and revise], [Detail filtering and sidebar return path], [A tap exposes products and active partners; dragging back removes the node and corresponding map marker.],
    [Operate without network], [Dependency and console inspection], [The base interface renders, but externally hosted MapLibre code and map tiles are a single point of failure for local or offline exhibition use.],
  ),
  caption: [Formative evaluation scenarios. Results describe prototype behavior or implementation evidence, not participant outcomes.],
) <tab-evaluation>
=== Findings

The central concept is represented coherently. A company exists as a catalogue item, a movable node, a detail record, a possible map marker, and an endpoint in a relation graph. The user does not need to switch modes to create or rearrange the network. Immediate redraw and animated edges provide visible cause and effect, and relation labels make the graph more informative than a purely decorative node-link diagram. The use of one pointer event model and a central placement function also reduces the gap between the browser mock-up and future tangible input.

The evaluation identified four priority limitations. First, robustness is insufficient for a permanent exhibit: external scripts and tiles should be bundled, cached, or replaced with an offline map package. A failed MapLibre load currently interrupts later JavaScript initialization. Second, accessibility is limited. Canvas nodes and edges have no semantic representation for screen readers, the company blocks are not keyboard-operable, and fixed overlay panels can obscure the working area on small displays. Third, the graph is authored entirely in code. Adding or correcting companies requires source changes, and several companies lack coordinates. Fourth, the completion state is not derived from a general model of industrial roles or connected paths; it is a hard-coded list of five identifiers.

== Discussion

The prototype supports the project's main design argument: industrial interdependence can be represented as a configuration that visitors construct rather than a diagram they only read. Direct manipulation, spatial layout, progressive detail, and animated relationships combine into a legible exploratory loop. The regional map and company-specific products connect abstract roles to a local context, which is important for the intended Freiberg museum setting.

However, the web prototype validates representation more strongly than tangibility. Mouse or touch dragging does not reproduce the weight, grasp, visibility, and group negotiation introduced by physical blocks. It also does not test occlusion under projection, camera tracking errors, accidental token movement, or whether several visitors can comfortably reach the same surface. Claims about collaboration and child engagement from prior work @horn2009 motivate the installation but cannot be transferred to this prototype without observation.

The current company graph raises a second interpretive issue. A museum visualization may be read as asserting factual supply relationships. Labels such as "sensor data" or "energy infrastructure" are plausible educational connections, but their provenance is not stored. Before exhibition, each node and edge should include a source, review status, date, and content owner. A role-based layer could then distinguish general process compatibility from verified cooperation between named companies.

=== Design Implications

The findings suggest that the next version should separate three concerns that are currently combined in one JavaScript file. A content layer should store companies, technologies, coordinates, sources, and reviewed relationships in a machine-readable format. A domain layer should interpret this graph, check whether a configuration forms a meaningful connected path, and generate explanatory feedback. The presentation layer should render the same state through canvas, a semantic text view, the map, and later the projector. This separation would allow museum staff to revise content without changing interaction code and would permit multiple front ends to share one verified model.

The exhibit should also communicate uncertainty explicitly. A solid link could indicate a sourced, company-specific relationship, while a visually distinct link could indicate general technological compatibility. Selecting an edge, not only a node, should reveal its explanation and source. This would turn the system from a persuasive visualization into an inspectable learning resource and reduce the risk that visitors mistake a simplified narrative for a complete supply-chain record.

=== Threats to Validity

The evaluation has deliberately narrow validity. It analyzes one repository snapshot and a desktop browser configuration; behavior may differ on large touchscreens, mobile browsers, or the final table. The browser smoke test confirms initial rendering and exposes dependency behavior, while interaction paths are primarily supported by source inspection rather than a repeatable automated test suite. No museum visitors or domain experts participated, so the report makes no empirical claim about intuitiveness, engagement, collaboration, knowledge gain, or the accuracy of company relationships. Finally, the graphical prototype omits the physical variables that motivate the project, including token shape and weight, reach, occlusion, camera confidence, projector brightness, and simultaneous access from different sides. These limitations define the scope of the conclusions and the tests required for the next iteration.

The most appropriate next evaluation is two-stage. First, conduct semi-structured interviews with museum and industry experts using the web prototype. Ask them to validate the narrative, terminology, companies, and relation labels and to identify missing roles. Second, after constructing a reliable tangible demonstrator, observe representative visitors performing short tasks without prior explanation. Measures should include task completion, time to first successful connection, number and type of assistance requests, explored companies, and whether participants can explain at least one value chain afterward. Brief interviews can then capture perceived clarity, interest, missing information, and confusion. Families and school groups should be observed as groups because collaboration is part of the interaction rationale.

== Conclusion and Future Work

This project translates the concept of a tangible industrial-network table into a functioning browser prototype. Ten regional actors, seventeen labeled relationships, company and product information, animated graph feedback, a completion state, and a geographic view together make an otherwise invisible ecosystem explorable. The implementation is deliberately simple and offers a clear integration boundary for later object recognition.

The prototype is ready for expert content review, but not for claims about visitor learning or for unattended museum deployment. Immediate engineering work should externalize the graph into a validated data file, complete geographic metadata, calculate completion from roles and connected paths, bundle all dependencies for offline operation, and add a semantic DOM or equivalent accessible view. The physical iteration should use fiducial markers or another robust recognition method, transform camera coordinates into projector coordinates, and provide clear feedback for lost or ambiguous tokens. Finally, the two-stage evaluation described above should compare the web and tangible versions where useful and test the installation in the intended social and spatial setting. These steps would turn the current concept demonstrator into both a maintainable exhibit and a defensible study of tangible interaction for regional industrial education.

== Acknowledgements

We thank Dr. Akshay Deshmukh for guidance within the course *Interactive Ubiquitous Systems and Intelligent User Interfaces*. Map data in the prototype is provided by OpenStreetMap contributors.


#pagebreak()
#bibliography("references.bib", style: "association-for-computing-machinery")