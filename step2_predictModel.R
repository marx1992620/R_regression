# subset data
data = na.exclude(data)
data$brand = as.factor(data$brand)
data$type = as.factor(data$type)
data$gas = as.factor(data$gas)
data$sys = as.factor(data$sys)
data$people = as.factor(data$people)
data$year = as.numeric(data$year)

# check numeric variables
check = subset(data,select=c(-type,-brand,-sys,-gas))
ggpairs(data = check)
# check numeric variables relation from each to each
ggcorr(data = newdata, palette = "RdYlGn",
       label = TRUE, label_color = "black")

# prepare traindata testdata
n = 0.3*nrow(data)
test.index = sample(1:nrow(data),n)
train = data[-test.index,]
test = data[test.index,]

# Regression
# lmtrain=lm(formula=price ~.,data=train)
lmtrain = lm(formula=price ~ gas+sys+year+cc+power+safe_bag+auto_chair+brand+type,data=train)
summary(lmtrain) # check adjusted R square and variables

# testMAPE
y = data$price[test.index]
yhat = predict(lmtrain,newdata=test,type="response")
test.MAPE = mean(abs(y-yhat)/y)
test.MAPE # should less than 10%

# CART
data.tree = rpart(price ~ gas+media+es++ss+sys+year+cc+power+l_chair+auto_chair+back_screen+ABS+window+hid+safe_bag+gps+keyless+led+tcs+people+brand+type,data=train)
data.tree$variable.importance

# trainMAPE
y = data$price[-test.index]
yhat = predict(data.tree,newdata=train,type="vector")
train.MAPE = mean(abs(y-yhat)/y)
train.MAPE # should less than 10%
# testMAPE
y = data$price[test.index]
yhat = predict(data.tree,newdata=test,type="vector")
test.MAPE = mean(abs(y-yhat)/y)
test.MAPE # should less than 10%, generally testMape > trainMape
