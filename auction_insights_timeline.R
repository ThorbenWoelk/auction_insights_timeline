# Plots an auction insights timeline from monthly Auction Insights data in CSV format (pulled from Google Adwords interface).
#
# PREREQUISITES
# =============
# LIBRARIES: ggplot2, dplyr, scales, readr
# DATA: An auction insights CSV file segmented by month and saved as 'data.csv' within the same folder as this code file.
# REFERENCE BRAND: Specify the brand name which replaces the initial "You" in the raw data. 
# This will be used as a reference category and plotted in green.  
brand.name <- "You" # REPLACE WITH YOUR BRAND NAME HERE

# import libraries
library(readr)
library(ggplot2)
library(scales)
library(dplyr)

# CHANGE FONT TYPE
# Uncomment this to change the font types in the output plot. Need `font_import()` to run the first time.
# library(extrafont) 
# loadfonts()

# import data
data.file <- "data.csv"
data <- read_csv(data.file, skip = 0) # download from AdWords interface in CSV format with month as segment and excluding top and summary rows


# Preliminary data cleaning
# =========================

# convert Impression share strings to percentages
data$`Impression share` = as.numeric(sub("%", "", data$`Impression share`))/100
# order URL levels reverse order alphabetically
data$`Display URL domain` <- factor(data$`Display URL domain`, 
                                    levels = rev(unique(data$`Display URL domain`)))

# replace "You" with brand name
levels(data$`Display URL domain`)[levels(data$`Display URL domain`)=="You"] <- brand.name


# EXCLUDE COMPETITORS
#levels(data$`Display URL domain`)[levels(data$`Display URL domain`)=="exclude.com"] <- NA


# convert month strings to date
data$Month = sub(" ", "-", data$Month)
data$Month = as.Date(paste("01-", data$Month, sep = ""), format = "%d-%B-%Y")

# delete IS<.1
data <- na.omit(data)


# Layout
# ======

lin.color<-scale_color_manual(values=c(
  "#40fdad", "#333333", "#d8122a","#f1961e", "#00a1bc", "#00aa5a",
  "#61193a", "#e65f2d", "#00596b", "#000000",
  "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000",
  "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000"))

style <- list(theme_minimal(),
              lin.color,
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

# Plotting
# ========

# ADJUST HEIGHT AND WIDTH OF THE PLOT BELOW
pdf(file="auction_insights.pdf", width = 8, height = 3) 

final_plot <- ggplot(data = data, aes(y = data$`Impression share`, 
           x = Month, 
           colour = relevel(data$`Shop display name`, ref = brand.name))) +
  geom_line(size = 0.5) +  
  geom_point(size = 1) +  
  style +
  ylab("Impression Share") +
  scale_x_date(date_breaks = "1 month", date_minor_breaks = "1 week", date_labels = "%b-%y") +
  scale_y_continuous(breaks = seq(0.1, 1, 0.1), labels = scales::percent)

final_plot

dev.off()
