# 下載所需工具包
pack = c("DiagrammeR","RGtk2","xgboost","readr","stringr","caret","car")
for(i in pack){install.packages(i)}
sapply(pack,FUN = library,character.only=T)

# 將資料格式(Data.frame)用xgb.DMatrix()轉為 xgboost 的稀疏矩陣
brand_onehot = as.data.frame(model.matrix(~brand-1,data))
type_onehot = as.data.frame(model.matrix(~type-1,data))
gas_onehot = as.data.frame(model.matrix(~gas-1,data))
sys_onehot = as.data.frame(model.matrix(~sys-1,data))
datamatrix = cbind(select_if(data,is.numeric),brand_onehot,type_onehot,gas_onehot,sys_onehot)

# 切割train test資料轉matrix
n=0.3*nrow(datamatrix)
test.index=sample(1:nrow(datamatrix),n)
train=datamatrix[-test.index,]
test=datamatrix[test.index,]

dtrain = xgb.DMatrix(data = as.matrix(train),
                     label = train$price)
dtest = xgb.DMatrix(data = as.matrix(test),
                    label = test$price)

# 設定xgb.params 的參數
xgb.params = list(
  # col的抽樣比例，越高表示每棵樹使用的col越多，會增加每棵小樹的複雜度
  colsample_bytree = 0.5,                    
  # row的抽樣比例，越高表示每棵樹使用的col越多，會增加每棵小樹的複雜度
  subsample = 0.5,
  # gbtree(樹)或gblinear(線性函式)
  booster = "gblinear",
  # 樹的最大深度，越高表示模型可以長得越深，模型複雜度越高
  max_depth = 15,           
  # [0,1]boosting會增加被分錯的資料權重，而此參數是讓權重不會增加的那麼快，因此越大會讓模型愈保守
  eta = 0.1,
  # 或用"mae"也可以
  eval_metric = "rmse",
  # reg:linear(回歸線性) multi:softmax(多分類問題) reg:logistic(邏輯回歸)
  objective = "reg:linear",
  nthread = 3,
  # [0,無限大]越大，模型會越保守，相對的模型複雜度比較低
  gamma = 0)

# 使用xgb.cv()，tune 出最佳的決策樹數量
cv.model = xgb.cv(
  params = xgb.params, 
  data = dtrain,
  nfold = 5,     # 5-fold cv
  nrounds = 100,   # 測試1-100，各個樹總數下的模型
  # 如果當nrounds < 30 時，就已經有overfitting情況發生，那表示不用繼續tune下去了，可以提早停止                
  early_stopping_rounds = 30, 
  print_every_n = 20 # 每20個單位才顯示一次結果，
)
# 繪圖
tmp = cv.model$evaluation_log
plot(x=1:nrow(tmp), y= tmp$train_rmse_mean, col='red', xlab="nround", ylab="rmse", main="Avg.Performance in CV") 
points(x=1:nrow(tmp), y= tmp$test_rmse_mean, col='blue') 
legend("topright", pch=1, col = c("red", "blue"), 
       legend = c("Train", "Validation") )

# 獲得 best nround
best.nrounds = cv.model$best_iteration 
best.nrounds

# 用xgb.train()建立模型
xgb.model = xgb.train(paras = xgb.params, 
                      data = dtrain,
                      nrounds = best.nrounds) 

# 畫出 xgb 的所有決策樹
#　xgb.plot.tree(model = xgb.model) 

# 預測
xgb_y = predict(xgb.model, dtest)

# MAPE
MAPE = mean(abs(xgb_y - test$price)/test$price) 
MAPE
