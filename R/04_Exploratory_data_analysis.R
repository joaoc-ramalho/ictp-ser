# --------------------------------------------------#
# Scientific computing
# ICTP/Serrapilheira 2022
# Script to perform exploratory data analysis
# For more explanations follow the tutorial at:
# First version 2022-07-13
# --------------------------------------------------#


#Exploratory data analysis consists in take a look on data before do anything
#on it, knowing its distribution and this type of thing

# Loading the data
data(iris)

head(iris)
summary(iris)

## The functions `aggregate` and `tapply` --------------------------------------

table(iris$Species)
# The function table will give us how many there are of each variable of a collumn
# or a vector


# sepal length mean per species
tapply(X = iris$Sepal.Length, INDEX = list(iris$Species), FUN = mean)
#tapply is used when we want to apply a function by groups of our data
#the first argument is vector, the second is the condition in which we
#want to aggregate our data (should be a list) and the third is the function
#we want to apply

# the same operation, using another function, other arguments and other output
aggregate(x = iris$Sepal.Length, by = list(iris$Species), FUN = mean)
# still the same operation, the same function but a different notation
aggregate(Sepal.Lengt ~ Species, data = iris, mean)


## NAs and zeroes --------------------------------------------------------------
apply(iris, 2, function(x) sum(is.na(x)))
# each TRUE output can be readed by R as "1".  So, the sum of the "is.na()"
# function will give us the total number of NAs

#The same as

count_na <- function(x){
  print(sum(is.na(x)))
}
apply(iris, 2, count_na)

## Descriptive statistics ------------------------------------------------------
vars <- iris[, -5]
# saving all columns except by the one with the species name

### Measures of central tendency

apply(vars, 2, mean)
#mean of each collumn

apply(vars, 2, median)
#median of each collumn

freq_sl <- sort(table(iris$Sepal.Length), decreasing = TRUE)
freq_sl[1]
#first we used the table() to see how much each values of the Sepal.Lenght were
#repeating
#Then we used sort( ..., decreasing = TRUE) to ordenate this values from the one
#that repeats more to the ones that less repeat, and saved it in a object "freq_sl"
#At the end we called freq_sl[1], to see the first element of this object. In
# other words, to se the value of "Sepal.Length" which repeats the most.


### Measures of dispersion
apply(vars, 2, var)
#var() function calculates the variance

sd01 <- apply(vars, 2, sd)
# another way:
sd02 <- apply(vars, 2, function(x) sqrt(var(x)))
sd01
sd02
sd01 == sd02


cv <- function(x){
  sd(x) / mean(x) * 100
}
apply(vars, 2, cv)


# quartiles (four quantiles)
apply(vars, 2, quantile)
# 5%, 50% e 95%
apply(vars, 2, quantile, probs = c(0.05, 0.5, 0.95))


# range function return the min and max
apply(vars, 2, range)

# applying the diff function to the range result, we have the desired value
# a good practice is to never overwrite an existing object in R, so
# never name an object with an already existing name
my_range <- function(x){
  diff(range(x))
}
apply(vars, 2, my_range)


apply(vars, 2, IQR)

# Correlation ------------------------------------------------------------------
cor(vars)
# gives the correlation number of each variable (column)

# Graphical methods ------------------------------------------------------------
barplot(table(iris$Species))


par(mfrow = c(2, 2))
hist(iris$Sepal.Length)
hist(iris$Sepal.Width)
hist(iris$Petal.Length)
hist(iris$Petal.Length)
par(mfrow = c(1, 1))

par(mfrow = c(1, 2))
hist(iris$Sepal.Width)
hist(iris$Sepal.Width, breaks = 4)
par(mfrow = c(1, 1))


par(mfrow = c(1, 2))
hist(iris$Sepal.Width)
hist(iris$Sepal.Width, freq = FALSE)
par(mfrow = c(1, 1))


par(mfrow = c(1, 2))
# ploting the density curve
plot(density(iris$Sepal.Width))

#  ploting the density curve over the density histogram
hist(iris$Sepal.Width, freq = FALSE)
lines(density(iris$Sepal.Width), col = "blue")
par(mfrow = c(1, 1))
#to add things to a graphic, we just need to write the code right above. Up here
#we putted the density line just by writing its code above the code of the "main
# graph" (the histogram)

boxplot(iris$Sepal.Length)
boxplot(iris$Sepal.Width)
boxplot(iris$Petal.Length)
boxplot(iris$Petal.Width)


boxplot(Sepal.Length ~ Species, data = iris)
# Here we are coding for a boxplot of Sepal.Lenght, but dividing the data trough
#"Species", by typing 'Sepal.Length ~ Species'
#The argument "data" its just telling to the function were the column "Sepal.Length"
#are comming from

boxplot(Sepal.Width ~ Species, data = iris)
boxplot(Petal.Length ~ Species, data = iris)
boxplot(Petal.Width ~ Species, data = iris)

#making a box plot
boxplot(iris$Sepal.Width)

#Identifying and removing the outliers
my_boxplot <- boxplot(iris$Sepal.Width, plot = FALSE)
my_boxplot

# the object is a list and the outliers are stored in the $out element of the list
outliers <- my_boxplot$out

# what is the position of the outliers
which(iris$Sepal.Width %in% outliers)

# let's use the position to index the object
iris[which(iris$Sepal.Width %in% outliers), c("Sepal.Width", "Species")]


boxplot(Sepal.Width ~ Species, data = iris)
my_boxplot2 <- boxplot(Sepal.Width ~ Species, data = iris, plot = FALSE)
my_boxplot2
# the object is a list and the outliers are stored in the $out element of the list
outliers2 <- my_boxplot2$out

# in this case, we only want the outliers of the setosa species
# let's use the position to index the object
iris[iris$Sepal.Width %in% outliers2 &
       iris$Species == "setosa",
     c("Sepal.Width", "Species")]


# Checking if the data follow a normal distribution ----------------------------

par(mfrow = c(1, 3))
# When the data is normally distributed, the scatterplot formed by the qqnorm()
#will make a straight line
qqnorm(iris$Sepal.Length[iris$Species == "setosa"],
       main = "setosa")
qqline(iris$Sepal.Length[iris$Species == "setosa"])
qqnorm(iris$Sepal.Length[iris$Species == "versicolor"],
       main = "versicolor")
qqline(iris$Sepal.Length[iris$Species == "versicolor"])
qqnorm(iris$Sepal.Length[iris$Species == "virginica"],
       main = "virginica")
qqline(iris$Sepal.Length[iris$Species == "virginica"])
par(mfrow = c(1, 1))


# Relationship between variables -----------------------------------------------

pairs(vars)


# EXCEPTIONALLY let's load the package now, as this is a bonus exercise.
library("GGally")
ggpairs(vars)

install.packages("GGally")
