# prepare environment
setwd("e:/r_work/car_predict")
pack = c("C50","tree","rpart","randomForest","GGally","modeldata","dplyr","sqldf","ggplot2", "GGally","ggfortify","e1071","vcd","jsonlite","mice","nortest")
for(i in pack){install.packages(i)}
sapply(pack,FUN = library,character.only=T)
search() # check packages

# load file
xcsv = read.table("path.csv",header=T,sep=",") # load csv file from path
xjson = fromJSON(file = "path.json") # load json file from path

# change data format
json_data_frame = as.data.frame(xjson) # JSON turn to be dataframe 
xdataframe = fromJSON(xjson) # JSON turn to be dataframe
xjson = toJSON(xdataframe) # dataframe turn to be JSON 
df = tbl_df(xcsv) # table turn to be dataframe

# change data format
df$column = as.numeric(df$column)
as.numeric(xdata) 
as.charater(xdata) 
as.logical(xdata)

# check data
str(data)
names(data) # check column name
dim(data) # check dimension
is.na(data) # check na
sum(is.na(data$column)) # sum na in data$column
data2 = na.exclude(data) # exclude na in data
list = distinct(data,element) # check elements in data
print(list)

# select data from dataframe
subdata = subset(df,year < 10 & year > 0,select=c(column1,column2)) # select 0<year<10
subdata = subset(df,brand=="Mazda") # select brand=Mazda and all column
subdata = df[df$brand=="Mazda",] # select brand=Mazda and all column

# dataframe merge
rbind(x, y) # merge row 
cbind(x, y) # merge column 
merge(x, y, by = "name") # merge by column=name

# save data
save(lmtrain, file = "regression_model.Rdata")
saveRDS(lmtrain, file = "regression.rda")
write.table(lmtrain[["coefficients"]], file = "regression.CSV", sep = ",")
write.table(data, file = "dataname.csv", sep = ",",col.names=TRUE,row.names = FALSE)
