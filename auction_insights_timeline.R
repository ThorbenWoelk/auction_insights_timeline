library(readr)
library(ggplot2)
library(scales)
library(dplyr)
# library(extrafont) # Extrafont let's you change the font types in the output plot. The first time you are using this, you need to run 'font_import()'
# loadfonts() # uncomment to use different font types you can specify below

data <- read_csv("data.csv", skip = 0) # download from AdWords interface in CSV format with month as segment and excluding top and summary rows

# ==== Preliminary data cleaning ====
# convert IS strings to percentages
data$`Impression share` = as.numeric(sub("%", "", data$`Impression share`))/100
# order URL levels reverse order alphabetically
data$`Display URL domain` <- factor(data$`Display URL domain`, levels = rev(unique(data$`Display URL domain`)))
# replace "You" with brand name 
levels(data$`Display URL domain`)[levels(data$`Display URL domain`)=="You"] <- "CHANEL" ##### REPLACE "CHANEL" WITH YOUR BRAND NAME HERE

# exclude some competitors?
#levels(data$`Display URL domain`)[levels(data$`Display URL domain`)=="exclude.com"] <- NA 


# convert month strings to date
data$Month = sub(" ", "-", data$Month)
data$Month = as.Date(paste("01-", data$Month, sep = ""), format = "%d-%B-%Y")
# delete IS<.1 and sort desc by name
data <- na.omit(data[order(data$`Display URL domain`, decreasing = FALSE),])


# ==== Layout ====
lin_color<-scale_color_manual(values=c(
  "#40fdad", "#333333", "#d8122a","#f1961e", "#00a1bc", "#00aa5a", 
  "#61193a", "#e65f2d", "#00596b", "#000000",
  "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000",
  "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000"))
style <- list(theme_minimal(),
              lin_color,
              theme(axis.title.x=element_blank(), 
                    # axis.title.y=element_text(size=10, vjust = 3, family = "DINPro-Regular"), # uncomment to specify a different font type for title axis y
                    # legend.text = element_text(size=10, family = "DINPro-Regular"), # uncomment to specify a different font type for text in legend
                    legend.title = element_blank(),
                    # axis.text.x = element_text(size=8, vjust = 3, family = "DINPro-Regular"), # uncomment to specify a different font type for text on x axis
                    plot.title = element_text(hjust = 0.4),
                    panel.grid.major.x = element_blank(),
                    panel.grid.minor.x = element_blank(),
                    panel.grid.minor.y = element_blank(),
                    axis.ticks=element_blank(), 
                    legend.position="top"
              ))

# ==== Plotting ====

pdf(file="auction_insights.pdf", width = 8, height = 3) #### ADJUST HEIGHT AND WIDTH OF THE PLOT HERE
ggplot() + 
  geom_line(aes(y = data$`Impression share`, x = data$Month, colour = relevel(data$`Display URL domain`, ref = "CHANEL")), size = 0.5) +  ##### REPLACE "CHANEL" WITH YOUR BRAND NAME HERE
  geom_point(aes(y = data$`Impression share`, x = data$Month, colour = relevel(data$`Display URL domain`, ref = "CHANEL")), size = 1) +  ##### REPLACE "CHANEL" WITH YOUR BRAND NAME HERE
  style + 
  ylab("Impression Share") + 
  scale_x_date(date_breaks = "1 month", date_minor_breaks = "1 week", date_labels = "%b-%y") + 
  scale_y_continuous(breaks = seq(0.1, 1, 0.1), labels = scales::percent)
dev.off()

