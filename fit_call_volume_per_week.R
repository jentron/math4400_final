## use hackathon.R to get the call volume by week data frame
head(df)
data <- data.frame(df$callVolume, df$week)
for(i in 2:10){
  data <-cbind(data, df$week^i)
}

names(data) <- c("callVolume", paste( "Week", 1:10, sep=""));
head(data)

library(leaps)
bkw.subsets<-regsubsets(callVolume~., data=data, method="backward", nvmax = 10)
plot(bkw.subsets, main="Best Subsets")
bkw.summary<-summary(bkw.subsets)
print(bkw.summary)
which.max(bkw.summary$adjr2)
which.max(bkw.summary$bic)
plot(bkw.summary$adjr2,xlab = 'Number of variables',
     ylab='Adjusted R-squared (larger is better)',type = 'l')
points(which.max(bkw.summary$adjr2),
       bkw.summary$adjr2[which.max(bkw.summary$adjr2)],
       col='red',cex = 2, pch = 20)


plot(bkw.summary$bic,xlab = 'Number of variables',
     ylab='BIC (smaller is better)',type = 'l')
points(which.min(bkw.summary$bic),
       bkw.summary$bic[which.min(bkw.summary$bic)],
       col='red',cex = 2, pch = 20)


#Library and data preparation

library(glmnet)

grid = 10^seq(10,-2,length = 100)#Tuning parameter: Possible values of lambda
##set.seed(42)
train = sample(c(1:dim(data)[1]),.7*dim(data)[1],replace = FALSE)
test =(-train)
#Format the data
y = data$callVolume
x = model.matrix(callVolume~., data = data)#Needed for glmnet

#LASSO model
lasso.model = glmnet(x[train,],y[train], alpha = 1, lambda = grid) # , nvmax = 19 Alpha =1 is LASSO, alpha = 0 is RIDGE, Variables automatically scaled #Standardize = FALSE
names(lasso.model)
plot(lasso.model)

cv.out = cv.glmnet(x,y, alpha = 1)#Cross validation to choose the best value of lambda
plot(cv.out)
best_lambda = cv.out$lambda.min
best_lambda
# Best lambda is 2.129
lasso.pred = predict(lasso.model,s = best_lambda , newx = x)

mean((lasso.pred-y)^2)#MSE
lasso.coef = predict(lasso.model,type = 'coefficients',s=best_lambda)[1:dim(x)[2],]
lasso.coef
lasso.coef[lasso.coef!=0]

lm.lasso <- lm(callVolume~Week1+Week3+Week4, data=data)
summary(lm.lasso)

lm.bstsub <- lm(callVolume~Week3+Week4+Week5, data=data)

