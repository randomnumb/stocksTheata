if(!require(pacman)) install.packages("pacman")
pacman::p_load(quantmod,data.table,ggplot2,git)

#option_data <- getOptionChain("SPY")

#puts <- data.table(option_data$puts)

symbol <- "SPY"

getSymbols(symbol, from = "2018-01-01", to = "2023-06-25")  # Specify the desired date range

spy <- data.table(dt=index(SPY),open=SPY$SPY.Open,close=SPY$SPY.Close)

spy[,prior_close:=shift(close.SPY.Close,n=1)]
spy[,overnight_delta:=open.SPY.Open-prior_close]
spy[,day_delta:=close.SPY.Close-open.SPY.Open]

ggplot(data=spy,aes(x=as.Date(dt),y=overnight_delta,group=1)) + 
  geom_line() + 
  theme_bw()

ggplot(data=spy,aes(x=factor(year(as.Date(dt))),y=overnight_delta)) +
  geom_boxplot() +
  theme_bw()

summary_table <- spy[, .(mean_overnight_delta = mean(overnight_delta),
                         median_overnight_delta = median(overnight_delta),
                         min_overnight_delta = min(overnight_delta),
                         max_overnight_delta = max(overnight_delta)), by = year(dt)]




SPY$SPY.Close
