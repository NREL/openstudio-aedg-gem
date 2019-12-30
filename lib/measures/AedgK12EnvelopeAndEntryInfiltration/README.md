

###### (Automatically generated documentation)

# AedgK12EnvelopeAndEntryInfiltration

## Description


## Modeler Description


## Measure Type
ModelMeasure

## Taxonomy


## Arguments


### Envelope Infiltration Level (Not including Occupant Entry Infiltration)

**Name:** infiltrationEnvelope,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

### Occupant Entry Infiltration Modeling Approach

**Name:** infiltrationOccupant,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

### Apply Occupant Entry Infiltration to ThermalZones on this floor.

**Name:** story,
**Type:** Choice,
**Units:** ,
**Required:** true,
**Model Dependent:** false

### Number of Primary Occupant Entry Points on Selected Floor.

**Name:** num_entries,
**Type:** Integer,
**Units:** ,
**Required:** true,
**Model Dependent:** false

### Number of Door Opening Events Per Person Per Day (2 is expected minimum for one entry and exit).

**Name:** doorOpeningEventsPerPerson,
**Type:** Double,
**Units:** ,
**Required:** true,
**Model Dependent:** false

### Pressure Difference Across Door At Occupant Entries (pa).

**Name:** pressureDifferenceAcrossDoor_pa,
**Type:** Double,
**Units:** ,
**Required:** true,
**Model Dependent:** false

### Total cost for all Envelope Improvements ($).

**Name:** costTotalEnvelopeInfiltration,
**Type:** Double,
**Units:** ,
**Required:** true,
**Model Dependent:** false

### Total cost for all Occupant Entry Improvements ($).

**Name:** costTotalEntryInfiltration,
**Type:** Double,
**Units:** ,
**Required:** true,
**Model Dependent:** false




