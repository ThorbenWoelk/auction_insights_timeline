Plotting a Timeline from AdWords Auction Insights Data
======================================================

This R code snippet allows to plot a timeline from Google AdWords Auction Insights data.
In order to make it run smoothly, just follow the short guide below.

1. The following packages have to be installed using the `install.packages()` command in your R console:  
- readr
- ggplot2
- scales
- dplyr

2. In order to set your own brand as a reference category in the plot, open the 'auction_insights_timeline.R' file and adjust all rows where the comment says `##### REPLACE "MYBRAND" WITH YOUR BRAND NAME HERE`.

3. From the AdWords interface, download the auction insights data for the time range of interest. **Make sure this is in CSV format with month as segment and excluding top and summary rows** (just click on 'more options' in order to make those setting).

4. And that should do it! Run the code (e.g. in RStudio) and see if the PDF output is correctly created (see figure below for what it should look like).
In case you want to adjust on the size of the plot or change the font type, you can do so by following the comments in the code.

![Auction Insights Plot](https://github.com/ThorbenWoelk/auction_insights_timeline/blob/master/timeline_auction_insights.PNG)
