## Wbp Meldingenregister in R

Deze repository bevat mijn scripts en de uitvoerbestanden voor het inlezen van de JSON-bestanden van het [Wbp Meldingenregister](https://www.collegebeschermingpersoonsgegevens.nl/asp/orsearch.asp) in R.

De JSON-bestanden werden beschikbaar gesteld voor de [hackathon op 30 mei 2015](https://decorrespondent.nl/2662/Help-mee-de-datakluwen-van-de-overheid-in-kaart-te-brengen/236686493846-1584a8f4) georganiseerd door De Correspondent. 

Omdat ik via Coursera bezig ben met de [Data Science Specialization](https://www.coursera.org/specialization/jhudatascience/1) bij John Hopkins University, leek het me leuk en leerzaam om te kijken hoe je deze bestanden inleest in R.

Het script verondersteld dat de JSON-bestanden in de subdirectory Data van de R werkdirectory staan.

De uitvoer zijn tab-gescheiden tekstbestanden:
* melding.txt
* verantwoordelijke.txt
* betrokkene.txt
* persoonsgegeven.txt
* bijzonder_gegeven.txt
* ontvanger.txt
* doelen.txt

Eén melding is gekoppeld aan één of meerdere verantwoordelijken, betrokkenen, ontvangers en doelen. 
Eén betrokkene is gekoppeld aan één of meerder persoonsgegevens en eveneens aan één of meerdere categorieën van bijzondere gegevens.

De tab-gescheiden tekstbestanden zijn eenvoudig te openen in Excel.

Het draaien van het scipt duurt op mijn laptop uren. Er zijn vast efficiëntere manieren om de gegevens in te lezen ;-)

De uitvoerbestanden staan ingepakt als meldingen.zip in de repository. 