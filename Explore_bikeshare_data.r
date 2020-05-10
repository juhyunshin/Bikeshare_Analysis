install.packages('ggplot2')
library(ggplot2)
install.packages('ggthemes', dependencies = TRUE)
library(ggthemes)
install.packages('dplyr')
library(dplyr)
install.packages('rlang')
library(rlang)
install.packages('chron')
library(chron)
install.packages('scales')
library(scales)
install.packages('hms')
library(hms)


ny = read.csv('new_york_city.csv')
wash = read.csv('washington.csv')
chi = read.csv('chicago.csv')

head(ny)

head(wash)

head(chi)



right = function(data, num_char) {
  substr(data,nchar(as.character(data)) - (num_char-1),nchar(as.character(data)))
}
mid = function(data,num_char) {
  substr(data,nchar(as.character(data)) - (num_char-1),nchar(as.character(data))-3)
}


# right(ny$End.Time,8)
# mid(ny$End.Time,8)

ny <- ny %>% mutate(ny.end.time = mid(ny$End.Time,8))
ny <- subset(ny,User.Type == 'Customer' | User.Type == 'Subscriber')
head(ny)
?as.times

length(levels(ny$Start.Station))
length(levels(ny$End.Station))
summary(ny)
twohr = "2 hour"
sixhr = "6 hour"

graph = function(dat, e.time, breaks){
  ggplot(data=subset(dat,User.Type == 'Customer' | User.Type == 'Subscriber'),
         aes(x=as.POSIXct(e.time,format="%H:%M"))) +
    geom_histogram(fill = "lightblue",color = "grey50") +
    scale_x_datetime(date_labels = "%R",date_breaks = breaks) +
    scale_y_continuous(label=comma_format()) +
    xlab("Time") + ylab("Count") +
    facet_grid(~User.Type)
}

#NY: what time of day are bikes most commonly checked in?
graph(ny,ny$ny.end.time,sixhr) +
  ggtitle('NY Bike Check-in Times for Customers & Subscribers')
#Subscriber peak hours are at the common start and end times of a work
#Customers, the category where tourists would fall, 
#tend to check in bikes throughout the day starting
#late morning
#########

chi <- chi %>% mutate(chi.end.time = mid(chi$End.Time,8))
chi <- subset(chi,User.Type == 'Customer' | User.Type == 'Subscriber')
head(chi)
#Chi: What time of day are bikes most commonly checked in?
graph(chi,chi$chi.end.time,sixhr) +
  ggtitle('Chi Bike Check-in Times for Customers & Subscribers')
#Similar to NY, subscriber peak hours at the typical start/end times of work day
#More customers tend to use Bike as form of transit in Chicago
#than in NY, with a clear peak in the 4PM hour.
#Whereas NY customer check in times were fairly stable throughout
#period of day that sees acitivity, 11AM - 7PM.
#########

wash <- wash %>% mutate(wash.end.time = mid(wash$End.Time,8))
wash <- subset(wash,User.Type == 'Customer' | User.Type == 'Subscriber')
head(wash)
#Wash: What time of day are bikes most commonly checked in?
graph(wash,wash$wash.end.time,sixhr) +
  ggtitle('Wash Bike Check-in Times for Customers & Subscribers')
#unlike NY & Chi, Wash has a disproportionate number of check-in
#times at the start of work day, as opposed to be more even between
#start and end of work day.
#There is a high frequency of customers consistently checking bikes in at 
#very early times of the day, starting at around 2AM. It's possible that
#there may be more regular customers than in the other two cities
#or possibly that there are errors in the system, since we would not
#expect so much activity so early in the day.
#########

names(ny)
#Combined data
ny2 = ny[,c(1:7,10)] %>% mutate(city = "ny") %>%
  rename(city.end.time = ny.end.time)
chi2 = chi[,c(1:7,10)] %>% mutate(city = "chi") %>%
  rename(city.end.time = chi.end.time)
wash2 = wash %>% mutate(city = "wash") %>%
  rename(city.end.time = wash.end.time)
all <- rbind(ny2,chi2,wash2)
levels(all$User.Type)

#All: What time of day are bikes most commonly checked in?
ggplot(data=subset(all,User.Type == 'Customer' | User.Type == 'Subscriber'), 
       aes(x=as.POSIXct(city.end.time,format="%H:%M"))) +
  geom_histogram(fill = "lightblue",color = "grey50") +
  scale_x_datetime(date_labels = "%R",date_breaks = "6 hour") +
  scale_y_continuous(label=comma_format()) +
  xlab("Time") + ylab("Count") +
  facet_grid(User.Type~city) +
  ggtitle('Bike Check-in Time by City')

ny = read.csv('new-york-city.csv')
wash = read.csv('washington.csv')
chi = read.csv('chicago.csv')

right = function(data, num_char) {
  substr(data,nchar(as.character(data)) - (num_char-1),nchar(as.character(data)))
}
mid = function(data,num_char) {
  substr(data,nchar(as.character(data)) - (num_char-1),nchar(as.character(data))-3)
}
# right(ny$End.Time,8)
# mid(ny$End.Time,8)


curr_yr = 2020

ny <- ny %>% mutate(ny.end.time = mid(ny$End.Time,8))
ny.age <- ny %>% mutate(age = (curr_yr - ny$Birth.Year)) 
ny.age <- ny.age %>% mutate(age_bucket = case_when(
    ny.age$age > 100 ~ "100+",
    ny.age$age > 75 & ny.age$age <= 100 ~ "76-100",
    ny.age$age > 50 & ny.age$age <= 75 ~ "51-75",
    ny.age$age > 25 & ny.age$age <= 50 ~ "26-50",
    ny.age$age <= 25 ~ "19-25"
  ))
ny.age <- subset(ny.age, !is.na(age_bucket))
ny.age <- subset(ny.age, User.Type == 'Customer' | User.Type == 'Subscriber')

head(ny.age)
table(ny.age$age_bucket)
names(ny.age)
class(ny.age$ny.end.time)

histogram = function(dat,e.time){
  ggplot(data=subset(dat, !is.na(age_bucket)),
         aes(x=age_bucket, y=as.POSIXct(e.time,format="%H:%M"))) +
    geom_boxplot(fill = "lightblue",color = "grey50") +
    scale_y_datetime(date_labels = "%R") +
    xlab("Age Bucket") + ylab("Time")
}

#NY: Are check in times different by age group?
histogram(ny.age,ny.age$ny.end.time) +
  facet_grid(~User.Type) +
  ggtitle('NY Age Bucket by Check-In Time')
rename(count(ny.age,User.Type,age_bucket), Freq = n)
table(ny.age$age_bucket)
table(ny.age$User.Type)
#No, Check in times are similar across age buckets,
#but different between customer and subscriber user types.
#Most used category are subscribers between ages of 26-50.
#Distribution for this category is similar to second most used category
#which are subscribers between ages of 51-75.


chi <- chi %>% mutate(chi.end.time = mid(chi$End.Time,8))
chi.age <- chi %>% mutate(age = (curr_yr - chi$Birth.Year))
chi.age <- chi.age %>% mutate (age_bucket = case_when(
  chi.age$age > 100 ~ "100+",
  chi.age$age > 75 & chi.age$age <= 100 ~ "76-100",
  chi.age$age > 50 & chi.age$age <= 75 ~ "51-75",
  chi.age$age > 25 & chi.age$age <= 50 ~ "26-50",
  chi.age$age <= 25 ~ "19-25"
))
chi.age <- subset(chi.age, !is.na(age_bucket))
chi.age <- subset(chi.age, User.Type == 'Customer' | User.Type == 'Subscriber')

#Chi: Are check in times different by age group?
histogram(chi.age,chi.age$chi.end.time) +
  facet_grid(~User.Type) +
  ggtitle('Chi Age Bucket by Check-In Time')
rename(count(chi.age,User.Type,age_bucket), Freq = n)
table(chi.age$age_bucket)
table(chi.age$User.Type)
#No, check in times are not different across age groups
#Chi has signficantly less Customers than subscribers.
#Chi only has 91 customers vs NY which has 4416.

#Chi & NY combined
chi.age <- chi.age %>% rename(city.end.time = chi.end.time) %>%
  mutate(city = "chi")
ny.age <- ny.age %>% rename(city.end.time = ny.end.time) %>%
  mutate(city = "ny")
all.age <- rbind(ny.age,chi.age)

#Chi & NY: Are check in times different by age group?
histogram(all.age,all.age$city.end.time) +
  facet_grid(User.Type~city) +
  ggtitle('Age Bucket by Check-In Time')
rename(count(all.age,User.Type,age_bucket), Freq = n)
table(all.age$age_bucket)
table(all.age$User.Type)
table(all.age$city)
#No, since distribution for each city was about the same from above.
#In general, there is a lot of activity around 3PM to 6PM.
#This could pose issues on supply depending on low/high frequency
#bike stations.

names(all.age)

ny = read.csv('new-york-city.csv')
wash = read.csv('washington.csv')
chi = read.csv('chicago.csv')

names(ny)
names(chi)
names(wash)

ny3 <- ny %>% mutate(city = "ny")
chi3 <- chi %>% mutate(city = "chi")
ny_chi <- rbind(ny3,chi3)

curr_yr = 2020
ny_chi <- ny_chi %>% mutate(age = (curr_yr - ny_chi$Birth.Year)) %>%
  mutate(hours = ny_chi$Trip.Duration / 60 / 60) %>%
  mutate(minutes = ny_chi$Trip.Duration / 60)
ny_chi <- subset(ny_chi, !is.na(age))
ny_chi <- subset(ny_chi, User.Type == 'Customer' | User.Type == 'Subscriber')
head(ny_chi)
#ny_chi_sub <- subset(ny_chi,hours < 6 | (age < 90 & age > 10))

#make this faster
#Do rental durations change by age?
ggplot(data = subset(ny_chi, !is.na(age)),
       aes(x=age, y=minutes)) +
  xlim(15,80) + ylim(0,120) +
  geom_point(alpha = 0.05,
             position = position_jitter(h=0),
             color = "blue") +
  stat_summary(geom="line",fun=mean) +
  stat_summary(geom="line",fun=quantile,
               fun.args = list(prob=0.1),linetype=2) +
  stat_summary(geom="line",fun=quantile,
               fun.args = list(prob=0.5),linetype=2) +
  stat_summary(geom="line",fun=quantile,
               fun.args = list(prob=0.9),linetype=2) +
  facet_grid(User.Type~city) +
  ggtitle('Age by Bike Rental Duration - Distribution')
#Tops of darkest regions shows there is a decline in duration
#as user's age increases. If there is a decline, it is very slight
#since the mean (solid line) and percentiles (dotted lines)
#are relatively flat.
#Additional insights from this visualization are that customers
#are concentrated in the under 40 age group, as seen by the darker
#blue area. 90% of subscribers rentals are less than 25 minutes
#(highest dotted line) indicating that subscribers most likely 
#have routes set prior to rental compared to customers.
#Gap between mean and median duration for subscribers is smaller
#in Chi than NY indicating that either Chi has more extreme outliers
#than NY or that NY has long-tailed distribution.

ny_chi <- ny_chi %>% arrange(desc(ny_chi$Trip.Duration))
head(ny_chi,25)
209952 / 60 / 60
24 * 60 * 60
dim(subset(ny_chi,Trip.Duration > 50000))[1]
50000 / 60 / 60
summary(ny_chi$age)
names(ny_chi)


system('python -m nbconvert Explore_bikeshare_data.ipynb')
