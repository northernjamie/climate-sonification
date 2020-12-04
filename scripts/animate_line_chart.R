# animate line chart
library(gganimate)
library(showtext)

font_add_google(name = "Open Sans", family = "open-sans")
showtext_auto()
anim_chart <- ggplot(data = temp_change) +
  geom_line(aes(x = Year, y = lowess_temp, group = geo),colour='white',size = 5, alpha=0.3) +
  geom_line(aes(x = Year, y = lowess_temp, group = geo),colour='#f4c907',size = 3, alpha=0.5) +
  geom_line(aes(x = Year, y = lowess_temp, group = geo),colour = "#f45207",size = 1.5, alpha=0.7) +
  geom_line(aes(x = Year, y = lowess_temp, group = geo),colour= "red", size = 1, alpha = 1) +
  geom_point(aes(x = Year, y = lowess_temp),colour='white', size = 8, alpha = 0.3) +
  geom_point(aes(x = Year, y = lowess_temp) ,colour='#f4c907', size = 6, alpha = 0.5) +
  geom_point(aes(x = Year, y = lowess_temp) ,colour='#f45207', size = 4, alpha = 0.7) +
  geom_point(aes(x = Year, y = lowess_temp) ,colour='red', size = 2, alpha = 1) +
  labs(y = "Degrees Celsius Difference", title = "Global Temperature - Annual Difference\nfrom the 1951 - 1980 Mean", caption = "Data: NASA | audio/visualisation: @northernjamie") +
  theme_minimal() +
  theme(legend.position = 'none',
        plot.background = element_rect(colour = 'black',
                                       fill = 'black'),
        panel.background = element_rect(colour = 'black',
                                        fill = 'black'),
        line = element_blank(),
        axis.text = element_text(colour="white",
                                 size = 8,
                                 family = 'open-sans'),
        plot.title = element_text(colour = 'white',
                                  size = 16,
                                  family = 'open-sans'),
        plot.caption = element_text(colour = 'white',
                                    size = 11,
                                    family = 'open-sans'),
        axis.title = element_text(colour = 'white',
                                  size = 10,
                                  family = 'open-sans'),) +
  transition_reveal(Year)

animate(anim_chart,nframes = nrow(temp_change), fps = 4, width = 16, height = 9, units = 'cm', res = 150)

anim_save(file = 'tempoutput/animate_line_4fps.gif')
