#Veikkausliigan tilastojen haku Instatin API-rajapinnasta
  
#Lataa kirjastot
install.packages("jsonlite")
install.packages("curl")
library(jsonlite)
library(dplyr)

#Base url
baseurl <- "http://mc.instatfootball.com/api/v1/matches/"

#Yksi ottelu
vl_ottelu <- fromJSON("http://mc.instatfootball.com/api/v1/matches/1142074")
vl_ottelu_players <- vl_ottelu$players
#VL kaudet:
url_vl_kaudet <- fromJSON("http://mc.instatfootball.com/api/v1/seasons?tournament_id=70")
url_kaudet <- fromJSON("http://mc.instatfootball.com/api/v1/seasons?tournament_id=1")

#VL kauden ottelut:
vl_kausi_2018 <- fromJSON("http://mc.instatfootball.com/api/v1/matches?locale=en&tournament_id=70&season_id=21")
vl_kausi_2017 <- fromJSON("http://mc.instatfootball.com/api/v1/matches?locale=en&tournament_id=70&season_id=19")
vl_kausi_2016 <- fromJSON("http://mc.instatfootball.com/api/v1/matches?locale=en&tournament_id=70&season_id=17")
vl_kausi_2015 <- fromJSON("http://mc.instatfootball.com/api/v1/matches?locale=en&tournament_id=70&season_id=15")
vl_kausi_2014 <- fromJSON("http://mc.instatfootball.com/api/v1/matches?locale=en&tournament_id=70&season_id=13")

#1. ja viimeinen kauden ottelu-id
first_14 <- url_vl_kaudet[url_vl_kaudet$id == 13, 3]
last_14 <- max(vl_kausi_2014[,1])
first_15 <- url_vl_kaudet[url_vl_kaudet$id == 15, 3]
last_15 <- max(vl_kausi_2015[,1])
first_16 <- url_vl_kaudet[url_vl_kaudet$id == 17, 3]
last_16 <- max(vl_kausi_2016[,1])
first_17 <- url_vl_kaudet[url_vl_kaudet$id == 19, 3]
last_17 <- max(vl_kausi_2017[,1])
first_18 <- url_vl_kaudet[url_vl_kaudet$id == 21, 3]
last_18 <- max(vl_kausi_2018[,1])

#Hae kaikki liigat
league_url <- "http://mc.instatfootball.com/api/v1/seasons?tournament_id="
pages <- list()
for (avain in 1:1000){
  leagues <- try(fromJSON(paste0(league_url, avain), flatten = TRUE))
  message("Retrieving page ", avain)
  if ( isTRUE(class(leagues)=="try-error" )) next
  pages[[avain+1]] <- cbind(avain,leagues)
}
leagues <- rbind_pages(pages[sapply(pages,length)>1])


#Kauden kaikkien pelien event-datan haku loop-rakenteella
#2014 vuoden events
pages <- list()
for (id in 242815:243067){
  events_14 <- fromJSON(paste0(baseurl, id), flatten = TRUE)
  message("Retrieving page ", id)
  pages[[id+1]] <- cbind(id,events_14$events)
}
events_14_all <- rbind_pages(pages[sapply(pages,length)>1])

write.csv2(events_14_all,file = "14_events.csv")

#2015 vuoden events
pages <- list()
for (id in 369037:369234){
  events_15 <- fromJSON(paste0(baseurl, id), flatten = TRUE)
  message("Retrieving page ", id)
  pages[[id+1]] <- cbind(id,events_15$events)
}
events_15_all <- rbind_pages(pages[sapply(pages,length)>1])

write.csv2(events_15_all,file = "15_events.csv")

#2016 vuoden events
pages <- list()
for (id in 507137:507323){
  events_16 <- fromJSON(paste0(baseurl, id), flatten = TRUE)
  message("Retrieving page ", id)
  pages[[id+1]] <- cbind(id,events_16$events)
}
events_16_all <- rbind_pages(pages[sapply(pages,length)>1])

write.csv2(events_16_all,file = "16_events.csv")

#2017 vuoden events
pages <- list()
for (id in 789829:790026){
  events_17 <- fromJSON(paste0(baseurl, id), flatten = TRUE)
  message("Retrieving page ", id)
  pages[[id+1]] <- cbind(id,events_17$events)
}
events_17_all <- rbind_pages(pages[sapply(pages,length)>1])

write.csv2(events_17_all,file = "17_events.csv")

#2018 vuoden events
pages <- list()
for (id in 1142074:1142271){
  events_18 <- fromJSON(paste0(baseurl, id), flatten = TRUE)
  message("Retrieving page ", id)
  pages[[id+1]] <- cbind(id,events_18$events)
}
events_18_all <- rbind_pages(pages[sapply(pages,length)>1])

write.csv2(events_18_all,file = "18_events.csv")

#Kausien eventien yhdist??minen samaan dataframeen
vuosi = 2014
events_14_all <- cbind(vuosi, events_14_all)
vuosi = 2015
events_15_all <- cbind(vuosi, events_15_all)
vuosi = 2016
events_16_all <- cbind(vuosi, events_16_all)
vuosi = 2017
events_17_all <- cbind(vuosi, events_17_all)
vuosi = 2018
events_18_all <- cbind(vuosi, events_18_all)

events <- bind_rows(events_14_all,events_15_all,events_16_all,events_17_all,events_18_all)


#Kauden kaikkien pelien players-datan haku loop-rakenteella
#2014 vuoden players
pages <- list()
for (id in 242815:243067){
  players_14 <- fromJSON(paste0(baseurl, id), flatten = TRUE)
  message("Retrieving page ", id)
  pages[[id+1]] <- cbind(id,players_14$players)
}
players_14_all <- rbind_pages(pages[sapply(pages,length)>1])

write.csv2(players_14_all,file = "14_players.csv")

#2015 vuoden players
pages <- list()
for (id in 369037:369234){
  players_15 <- fromJSON(paste0(baseurl, id), flatten = TRUE)
  message("Retrieving page ", id)
  pages[[id+1]] <- cbind(id,players_15$players)
}
players_15_all <- rbind_pages(pages[sapply(pages,length)>1])

write.csv2(players_15_all,file = "15_players.csv")

#2016 vuoden players
pages <- list()
for (id in 507137:507323){
  players_16 <- fromJSON(paste0(baseurl, id), flatten = TRUE)
  message("Retrieving page ", id)
  pages[[id+1]] <- cbind(id,players_16$players)
}
players_16_all <- rbind_pages(pages[sapply(pages,length)>1])

write.csv2(players_16_all,file = "16_players.csv")

#2017 vuoden players
pages <- list()
for (id in 789829:790026){
  players_17 <- fromJSON(paste0(baseurl, id), flatten = TRUE)
  message("Retrieving page ", id)
  pages[[id+1]] <- cbind(id,players_17$players)
}
players_17_all <- rbind_pages(pages[sapply(pages,length)>1])

write.csv2(players_17_all,file = "17_players.csv")

#2018 vuoden players
pages <- list()
for (id in 1142074:1142271){
  players_18 <- fromJSON(paste0(baseurl, id), flatten = TRUE)
  message("Retrieving page ", id)
  pages[[id+1]] <- cbind(id,players_18$players)
}
players_18_all <- rbind_pages(pages[sapply(pages,length)>1])

write.csv2(players_18_all,file = "18_players.csv")

#Kausien eventien yhdist??minen samaan dataframeen
vuosi = 2014
players_14_all <- cbind(vuosi, players_14_all)
vuosi = 2015
players_15_all <- cbind(vuosi, players_15_all)
vuosi = 2016
players_16_all <- cbind(vuosi, players_16_all)
vuosi = 2017
players_17_all <- cbind(vuosi, players_17_all)
vuosi = 2018
players_18_all <- cbind(vuosi, players_18_all)

players <- bind_rows(players_14_all,players_15_all,players_16_all,players_17_all,players_18_all)

#Pelaajastatsit omaan tauluun
library(reshape2)
player_avg_isi_18 <- group_by(players_18_all, display_name, player_id, position_id)

#Hae yleisin pelipaikka per pelaaja
table <- summarise(player_avg_isi_18,
                    mean_isi=mean(statistics.isi), 
                    sd_isi=sd(statistics.isi), 
                    sum_mof=sum(statistics.mof), 
                    avg_c=mean(statistics.c),
                    avg_cwp=mean(statistics.cwp),
                    avg_pa=mean(statistics.pa),
                    avg_pap=mean(statistics.pap),
                    avg_t=mean(statistics.t),
                    avg_lb=mean(statistics.lb))


#Termit
#mof = peliaika
#isi = instat index
#g = maali
#a = sy??tt??
#s = laukaus
#st = laukaus maalia kohti
#f = rikkeet
#fop = vastustajan rikkeet
#offs = paitsio
#pap = sy??tt??-%
#c = kaksinkamppailut
#cw = voitetut kaksinkamppailut
#cwp = voitettujen kaksinkamppailujen osuus %
#lb = pallonmenetykset
#t = taklaukset
#d = juostu et??isyys metrein??
#spdm = huippunopeus km/h
#spda = keskinopeus km/h