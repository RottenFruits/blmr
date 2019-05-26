# blmr

Bayesian linear model in R.

---
## How to install

You can install blmr running the following commands.

```r
devtools::install_github("RottenFruits/blmr")
```

## Example

Here are examples.

```r
library(blmr)

X <- runif(10, 0, 10)
y <- sin(X)
df <- data.frame(X, y)

model <- blm(y ~ X + I(X^2) + I(X^3) + I(X^4), df, 10)

df_test <- data.frame(X = runif(100, 0, 10), y = 0)
df_test <- df_test[order(df_test$X), ]

yhat <- predict(model, df_test, type = "response")
sq_hat <- predict(model, df_test, type = "sd")

#plot
plot(df$X, df$y)
lines(df_test$X, yhat)
lines(df_test$X, yhat + 2*sq_hat)
lines(df_test$X, yhat - 2*sq_hat)
```

## References


- 須山敦志, 2017, 『ベイズ推論による機械学習入門』, 講談社.