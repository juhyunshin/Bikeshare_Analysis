### Date created: May 9, 2020

### Programming for Data Science in R
by Juhyun Shin

### Exploring Bike Share Data
1) NY, CHI, DC: What time of day are bikes most frequently returned?
*Findings:* **In NY**, subscriber peak hours are at the common start and end times of a work customers, the category where tourists would fall, tend to check in bikes throughout the day starting late morning. **In Chi**, similar to NY, subscriber peak hours at the typical start/end times of work day more customers tend to use Bike as form of transit in Chicago than in NY, with a clear peak in the 4PM hour. Whereas NY customer check in times were fairly stable throughout period of day that sees acitivity, 11AM - 7PM. **In Wash**, unlike NY & Chi, Wash has a disproportionate number of check-in times at the start of work day, as opposed to be more even between start and end of work day. There is a high frequency of customers consistently checking bikes in at very early times of the day, starting at around 2AM. It’s possible that there may be more regular customers than in the other two cities or possibly that there are errors in the system, since we would not expect so much activity so early in the day.

2) NY, CHI: Are return times different by age group?
*Findings:* **In NY:** No, Check in times are similar across age buckets, but different between customer and subscriber user types. Most used category are subscribers between ages of 26-50. Distribution for this category is similar to second most used category which are subscribers between ages of 51-75. **In Chi:** No, check in times are not different across age groups. Chi has signficantly less Customers than subscribers. Chi only has 91 customers vs 4416 in NY. Chi & NY Combined: No, since distribution for each city was about the same from above. In general, there is a lot of activity around 3PM to 6PM. This could pose issues on supply depending on low/high frequency bike stations.

3) NY, CHI: Do rental durations differ by age?
*Findings:* Tops of darkest regions of the age to rental minutes shows there is a decline in duration as user’s age increases. But, the mean (solid line) and percentiles (dotted lines) are relatively flat. Additional insights from this visualization are that customers are concentrated in the under 40 age group, as seen by the darker blue area. 90% of subscribers rentals are less than 25 minutes (highest dotted line) indicating that subscribers most likely have routes set prior to rental compared to customers. Gap between mean and median duration for subscribers is smaller in Chi than NY indicating that either Chi has more extreme outliers than NY or that NY has long-tailed distribution.

### Data from Motivate bike share company
chicago.csv, new-york-city.csv, washington.csv

### Credits
Udacity Nanodegree Program
