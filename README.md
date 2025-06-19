# Transcriptomics
<p align="center">
  <img src="Assets/Reuma.jpg" alt="png van gewrichtsschade" width="600"/>
</p>

Door: Elbrich Bouma

Klas:BML2-C

---
## Inhoud

---
## H1 Inleiding
Reumatoïde artritis (RA) is een auto-immuunziekte gevonden in 0.5-1.0% van de wereldbevolking die die leidt tot langdurige gewrichtsontstekingen en aantasting van meerdere organen. (bron 2) RA is een erfelijke aandoening waarbij ongeveer 60% genetisch bepaald is, 30% hiervan wordt veroorzaakt door het HLA-DRB1 gen. Vooral veranderingen in ‘shared epitopes’, een belangrijk gebied binnen MHC klasse II-genen, heeft effect hierop (bron 1). Een ander gen sterk betrokken bij RA dat niet op het HLA regio ligt is PTPN22. Dit gen verminderd de signalen van B- en T-cell reptoren (bron 2). Het 1858t variant is een goede voorspellende marker voor de ontwikkeling van RA, vooral in combinatie met anti-citrullinated protein antibodies (ACPAs) (bron 3). Hoewel deze genen veel betrokken zijn bij RA, is er nog niet een duidelijke oorzaak voor RA. Er zijn veel verschillende genen die invloed hebben op het ontwikkelen van RA. Het doel van dit onderzoek is het vinden van genen en pathways betrokken bij RA m.b.v. transcriptomics.

---
## H2 Methode
Om de genen en pathways betrokken bij RA te identificeren, werd gebruik gemaakt van transcriptomics. (fig…).

### H2.1 Dataset
Voor de samples werden 4 synoviumbiopten van RA-patiënten (diagnose >12 maanden, ACPA-positief) en 4 van controles (ACPA-negatief) gesequenced. Hierna werd met R (versie….) een Transcriptomics analyse uitgevoerd 

### H2.2 Mapping en countmatrix
De reads werden uitgelijnd tegen een humaan genoomindex (GRCh38.p14) met behulp van RSUBread (versie……..). Hieruit volgen BAM-bestanden waaruit vervolgens de reads worden gemapt met Homo_Sapien.gtf. het aantal reads dat op elk gen valt werd geteld in een countmatrix.

### H2.3 Statistiek
Voor de statistiek werd een countmatrix verkregen via school. Hiermee werd een differentiele genexpressie-analyse uitgevoerd met behulp van DESeq2 (versie….) en gevisualiseerd met een vulcanoplot. Verder werd een GO-enrichmentanalyse uitgevoerd met behulp van goseq (versie….) en KEGG-pathway analyse met behulp van KEGGREST (vesie…..).

---
## H3 Resultaten
Om te achterhalen welke genen en pathways een rol spelen bij RA, werd de data geanalyseerd met behulp van een vulcanoplot, GO-enrichment en een pathway analyse.

### H3.1 Vulcanoplot
Om inzicht te krijgen in de genen die significant op- of neergereguleerd zijn bij RA, werd een volcano plot gemaakt. Dit liet zien dat 2085 genen significant opgereguleerd en 2487 genen significant neergereguleerd waren (fig…).

### H3.2 GO-analyse
Om een overzicht te krijgen van welke biologische processen significant betrokken zijn bij RA, werd een GO-analyse uitgevoerd. Hieruit bleek dat de tien meest significante processen vaak te maken hadden met het lumen of het imuunsysteem (fig…).

### H3.3 Pathways
Om te bepalen welke genen op of neergereguleerd waren bij de RA patienten werden deze vergeleken met het Rheumatoid Arthritis-pathway. Hierbij bleek dat meerdere genen, waaronder CD28 en CTL A4, waren opgereguleerd (fig….).

---
## H4 Conclusie
