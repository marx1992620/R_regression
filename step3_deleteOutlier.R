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
plot(lmtrain)
ggplot(lmtrain)
autoplot(lmtrain)

plot(res,y)
hist(res)
hist(absres)
boxplot(res)
boxplot(absres)

h=hist(res,col="red")
xfit=seq(min(res),max(res),length=40)
yfit=dnorm(xfit,mean=mean(res),sd=sd(res))
yfit=yfit*diff(h$mids[1:2])*length(res)
lines(xfit,yfit,col="blue",lwd=2)
box()

# check residual IQR sd
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

