# residauls from model predicted
y=data$price # data = data or train
yhat=predict(data.tree,newdata=data,type="vector") # CART, data = data or train
yhat=predict(lmtrain,newdata=data,type="response") # Regression, data = data or train
res=y-yhat
absres=abs(y-yhat)

# check normal distribution
shapiro.test(res)
shapiro.test(res)
pearson.test(res)
lillie.test(res)
sf.test(res)
cvm.test(res)
ad.test(res)

# QQPLOT check residuals
ggplot(res)
ggplot(absres)
autoplot(res)
autoplot(absres)

# check residual IQR sd
boxplot(res)
boxplot(absres)

quantile(res)
IQR(res)
s1=sd(res)
s1
quantile(absres)
IQR(absres)
s2=sd(absres)
s2

# define outlier
q1=quantile(res,1/4)
q3=quantile(res,3/4)
line1=q1-1.5*IQR(res)
line3=q3+1.5*IQR(res)

# delete outlier
newdata=cbind(data,y,yhat)
newdata=subset(newdata,y>(line1+yhat) & y<(line3+yhat))

