# prepare new traindata testdata
n=0.3*nrow(newdata)
test2.index=sample(1:nrow(newdata),n)
train2=newdata[-test2.index,]
test2=newdata[test2.index,]

# Regression
# lmtrain=lm(formula=price ~.,data=newdata)
lmtrain=lm(formula=price ~ gas+sys+year+safe_bag+auto_chair+window+cc+power+brand+type,data=train2)
summary(lmtrain)
# testMAPE
y=newdata$price[test2.index]
yhat=predict(lmtrain,newdata=test2,type="response")
test.MAPE=mean(abs(y-yhat)/y)
test.MAPE

# CART
data.tree=rpart(price ~ year+cc+people+power+ABS+tcs+sys+ss+brand+type+
                  gas,data=train2)
data.tree$variable.importance
# trainMAPE
y=newdata$price[-test2.index]
yhat=predict(data.tree,newdata=train2,type="vector")
train.MAPE=mean(abs(y-yhat)/y)
train.MAPE
# testMAPE
y=newdata$price[test2.index]
yhat=predict(data.tree,newdata=test2,type="vector")
test.MAPE=mean(abs(y-yhat)/y)
test.MAPE

# check residual IQR sd
quantile(res)
IQR(res)
s1=sd(res)
s1
quantile(absres)
IQR(absres)
s2=sd(absres)
s2

# wider prediction with absolute residuals standard deviation
s=s2
ynew=y
yy=cbind(absres,s,ynew)
yy=tbl_df(yy)

# new testMape
yy$ynew=yy$absres-yy$s
yy$ynew[yy$ynew<0]=0
test.MAPE=mean(yy$ynew/y)
test.MAPE

# new predictModel 
# Regression
lmtrain=lm(formula=price ~ gas+sys+year+safe_bag+auto_chair+window+cc+power+brand+type,data=newdata)
summary(lmtrain)
# CART
data.tree=rpart(price ~ year+cc+people+power+ABS+tcs+sys+ss+brand+type+
                  gas,data=newdata)
data.tree$variable.importance
