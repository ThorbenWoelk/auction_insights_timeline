library(readr)
library(ggplot2)
library(scales)
library(dplyr)
library(extrafont) # the first time you are using this, you need to run 'font_import()'
loadfonts()

data <- read_csv("data.csv", skip = 2) # make sure the data contains one header row only, holding the column names

# ==== Preliminary data cleaning ====
# convert IS strings to percentages
data$`Impression share` = as.numeric(sub("%", "", data$`Impression share`))/100
# convert month strings to date
data$Month = sub(" ", "-", data$Month)
data$Month = as.Date(paste("01-", data$Month, sep = ""), format = "%d-%B-%Y")
# delete IS<.1 and sort desc by name
data <- na.omit(data[order(data$`Display URL domain`, decreasing = FALSE),])
# order URL levels reverse order alphabetically
data$`Display URL domain` <- factor(data$`Display URL domain`, levels = rev(unique(data$`Display URL domain`)))


# ==== Layout ====
lin_color<-scale_color_manual(values=c(
  "#40fdad", "#333333", "#d8122a","#f1961e", "#00a1bc", "#00aa5a", 
  "#61193a", "#e65f2d", "#00596b", "#000000",
  "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000",
  "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000"))
style <- list(theme_minimal(),
              lin_color,
              theme(axis.title.x=element_blank(), 
                    axis.title.y=element_text(size=10, vjust = 3, family = "DINPro-Regular"),
                    legend.text = element_text(size=10, family = "DINPro-Regular"),
                    legend.title = element_blank(),
                    axis.text.x = element_text(size=8, vjust = 3, family = "DINPro-Regular"),
                    plot.title = element_text(hjust = 0.4),
                    panel.grid.major.x = element_blank(),
                    panel.grid.minor.x = element_blank(),
                    panel.grid.minor.y = element_blank(),
                    axis.ticks=element_blank(), 
                    legend.position="top"
              ))

# ==== Plotting ====

pdf(file="auction_insights.pdf", width = 7, height = 3)
ggplot() + 
  geom_line(aes(y = data$`Impression share`, x = data$Month, colour = data$`Display URL domain`), size = 0.5) + 
  style + 
  ylab("Impression Share") + 
  scale_x_date(date_breaks = "1 month", date_minor_breaks = "1 week", date_labels = "%b-%y") + 
  scale_y_continuous(breaks = seq(0.1, 1, 0.1))
dev.off()