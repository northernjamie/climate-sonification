
library(tidyverse)
library(audio)
library(googleLanguageR)
library(sound)

## Project Variables ----
tempo <- 240 # set the tempo - this must must be 60 x the fps of the animated line chart for them to match up
sample_rate <- 44100 # set the sample rate 

## Project Functions ----

# this fucntion is the bit that turns the frequency and duration values into a song. Might as well be magic
make_sine <- function(freq, duration) {
  wave <- sin(seq(0, duration / tempo * 60, 1 / sample_rate) *
                freq * 2 * pi)
  fade <- seq(0, 1, 50 / sample_rate)
  wave * c(fade, rep(1, length(wave) - 2 * length(fade)), rev(fade))
}

## Get and process the data ----

temp_change <- readr::read_csv("inputs/global_temp_change.csv") %>% 
  rename(lowess_temp = 'Lowess(5)') %>% 
  mutate(max_value = max(lowess_temp)) %>%
  mutate(note = (lowess_temp/max_value)) %>% # calculate the value as a percentage of the max 
  mutate(frequency = (note * 440)+330) %>% # turn the percentage into a musical note frequency
  mutate(duration = 1) %>% # set all durations to be equal to one
  mutate(geo = 'Global')
## Make the chart ----

ggplot(data = temp_change, aes(x = Year, y = lowess_temp)) + 
  geom_line()

## Make the audio

global_temp_change_wave <-
  mapply(make_sine, temp_change$frequency, temp_change$duration) 

# save the tune wav file
save.wave(global_temp_change_wave,paste0("output/temp_change_240bpm.wav"))

## creds for google talk ----

gl_auth("secret/data-sonification-tts-project-e68ab8e37964.json")

temp_change_data_min <- temp_change %>% 
  slice_min(lowess_temp, n=1, with_ties = F)

temp_change_data_min_wav <- mapply(make_sine,temp_change_data_min$frequency, 3)
save.wave(temp_change_data_min_wav, "output/temp_change_min.wav")


temp_change_data_max <- temp_change%>% 
  slice_max(lowess_temp, n=1, with_ties = F)

temp_change_data_max_wav <- mapply(make_sine,temp_change_data_max$frequency, 3)
save.wave(temp_change_data_max_wav, "output/temp_change_max.wav")


gl_talk(paste0("Difference between average global temperature each year from 1880 to 2019 and the average global temperature from 1951 to 1980. Lowest value is a difference of ",temp_change_data_min$lowess_temp ,"degrees celsius, which sounds like this:"),output="output/intro1.wav",name="en-GB-Wavenet-A")
gl_talk(paste0("Highest value is a difference of ", temp_change_data_max$lowess_temp ," degrees celsius, which sounds like this:"),output="output/intro2.wav",name="en-GB-Wavenet-A")

# prepare the wav files for garage band / audacity. Needs to be like this to match the beat to the covid-data
s_intro_gb <- appendSample("output/intro1.wav","output/temp_change_min.wav","output/intro2.wav","output/temp_change_max.wav")
saveSample(s_intro_gb,"output/global_temp_change_intro.wav", overwrite = T)



