setwd("d:/temp/hackathon")
dataDir <- "./data"
library(jsonlite)

fileNames <- list.files(dataDir, pattern="*.json", full.names=TRUE)

# Verwijder bestanden 
unlink("melding.txt")
unlink("verantwoordelijke.txt")
unlink("ontvangers.txt")
unlink("betrokkene.txt")
unlink("persoonsgegeven.txt")
unlink("bijzonder_gegeven.txt")
unlink("doel.txt")

write.table(paste("meldingsnummer", "description", "doorgifte_passend", "url", "doorgifte_buiten_eu", "naam_verwerking", "id", sep="\t"), file="melding.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(paste("meldingsnummer", "verantwoordelijke", "bezoekadres_regel1", "bezoekadres_regel2", "bezoekadres_regel3", "postadres_regel1", "postadres_regel2", "postadres_regel3", sep="\t"), file="verantwoordelijke.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(paste("meldingsnummer", "ontvanger", sep="\t"), file="ontvanger.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(paste("meldingsnummer", "betrokkene", "betrokkene_volgnummer", sep="\t"), file="betrokkene.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(paste("meldingsnummer", "betrokkene_volgnummer", "omschrijving", "verzameldoel", sep="\t"), file="persoonsgegeven.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(paste("meldingsnummer", "betrokkene_volgnummer", "categorie_bijzondere_gegevens", sep="\t"), file="bijzonder_gegeven.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(paste("meldingsnummer", "doel_van_verwerking", sep="\t"), file="doel.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)

meldingnr <- NULL
meldingen <- NULL
verantwoordelijken <- NULL
ontvangers <- NULL
betrokkenen <- NULL
persoonsgeg <- NULL
bijzgeg <- NULL
doelen <- NULL

adres <- function (a) {  
    x <- vector()
    if (!is.null(a)) {x <- unlist(strsplit(a, "[\r\n]"))}
    return (x)
}

for (f in fileNames) {
    print(f)
    json <- fromJSON(f)
    n <- colnames(json$meldingen)
    for (m in n) {
        if (!m %in% meldingnr) {
            # Melding
            meldingen <- append(meldingen, paste(m
                                               , paste(json$meldingen[, m]$description[!is.na(json$meldingen[, m]$description)], collapse = '')
                                               , paste(json$meldingen[, m]$doorgifte_passend[!is.na(json$meldingen[, m]$doorgifte_passend)], collapse = '') 
                                               , paste(json$meldingen[, m]$url[!is.na(json$meldingen[, m]$url)], collapse = '') 
                                               , paste(json$meldingen[, m]$doorgifte_buiten_eu[!is.na(json$meldingen[, m]$doorgifte_buiten_eu)], collapse = '')   
                                               , paste(json$meldingen[, m]$naam_verwerking[!is.na(json$meldingen[, m]$naam_verwerking)], collapse = '') 
                                               , paste(json$meldingen[, m]$id[!is.na(json$meldingen[, m]$id)], collapse = '') 
                                               , sep = "\t"))    
            # Verantwoordelijke
            for (l in 1:length(json$meldingen[, m]$verantwoordelijken)) {
                if (!is.null(json$meldingen[, m]$verantwoordelijken[[l]])) {
                    for (i in 1:length(json$meldingen[, m]$verantwoordelijken[[l]]$Naam)) {
                        bezoekadres <- adres(json$meldingen[, m]$verantwoordelijken[[l]]$Bezoekadres[i])
                        postadres <- adres(json$meldingen[, m]$verantwoordelijken[[l]]$Postadres[i])
                        verantwoordelijken <- append(verantwoordelijken, paste(m
                                                                              , json$meldingen[, m]$verantwoordelijken[[l]]$Naam[i]
                                                                              , bezoekadres[1]
                                                                              , bezoekadres[2]
                                                                              , bezoekadres[3]
                                                                              , postadres[1]
                                                                              , postadres[2]
                                                                              , postadres[3]
                                                                              , sep = "\t")) 
                    }
                }
            }
            
            # Ontvanger
            for (l in 1:length(json$meldingen[, m]$ontvangers)) {
                if (!is.null(json$meldingen[, m]$ontvangers[[l]])) {
                    for (i in 1:length(json$meldingen[, m]$ontvangers[[l]])) {
                        ontvangers <- append(ontvangers, paste(m
                                                             , json$meldingen[, m]$ontvangers[[l]][i]
                                                             , sep = "\t"))
                    }
                }
            }
            
            # Betrokkene
            id <- 0
            for (b in colnames(json$meldingen[, m]$betrokkenen)) {
                id <- id + 1
                betrokkenen <- append(betrokkenen, paste(m, b, id, sep='\t'))
                for (g in colnames(json$meldingen[, m]$betrokkenen[, b])) { 
                    if (g != "bijzonder"){
                        # Persoonsgegevens
                        d <- paste(json$meldingen[, m]$betrokkenen[, b][, g][!is.na(json$meldingen[, m]$betrokkenen[, b][, g])], collapse = '')
                        persoonsgeg <- append(persoonsgeg, paste(m, id, g, d, sep='\t'))      
                    } else  {
                        # Categorie bijzondere gegevens
                        for (i in 1:10) {
                            if (!is.na(json$meldingen[, m]$betrokkenen[, b]$bijzonder[i])) {
                                bijzgeg <- append(bijzgeg, paste(m, id, json$meldingen[, m]$betrokkenen[, b]$bijzonder[i], sep='\t'))    
                            }
                        }
                    }
                }    
            }
            
            # Doel
            for (l in 1:length(json$meldingen[, m]$doelen)) {
                if (!is.null(json$meldingen[, m]$doelen[[l]])) {
                    for (i in 1:length(json$meldingen[, m]$doelen[[l]])) {
                        doelen <- append(doelen, paste(m
                                                     , json$meldingen[, m]$doelen[[l]][i]
                                                     , sep = "\t"))  
                    }
                }
            }
        }
    }    
}

write.table(meldingen, file="melding.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(verantwoordelijken, file="verantwoordelijke.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(ontvangers, file="ontvanger.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(betrokkenen, file="betrokkene.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)
write.table(persoonsgeg, file="persoonsgegeven.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE) 
write.table(bijzgeg, file="bijzonder_gegeven.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)    
write.table(doelen, file="doel.txt", append = TRUE, col.names = FALSE, row.names = FALSE, quote = FALSE)