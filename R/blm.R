#' Learning bayseian linear model
#'
#' @param formula an object of class "formula" (or one that can be coerced to that class): a symbolic description of the model to be fitted. The details of model specification are given under ‘Details’.
#' @param data an optional data frame, list or environment (or object coercible by as.data.frame to a data frame) containing the variables in the model. If not found in data, the variables are taken from environment(formula), typically the environment from which lm is called.
#' @param lambda accuracy parameter.
#' @export
#'
blm <- function(formula, data, lambda){
  #fields
  me <- list(formula = formula,
             data = data,
             lambda = lambda,
             Lambda_hat = 0,
             Lambda_hat_inv = 0,
             m_hat = 0,
             model_evidence = 0)

  #model
  mm <- model.matrix(formula, data) #design matrix
  y <- model.response(model.frame(formula, data)) #response variable

  #hyper parameter
  Lambda <- diag(ncol(mm))
  m <- rep(0, ncol(mm))

  #learning
  Lambda_hat <- lambda*(t(mm) %*% mm) + Lambda
  Lambda_hat_inv <- solve(Lambda_hat)
  m_hat <- Lambda_hat_inv %*% t((lambda * (y %*% mm) + t(Lambda %*% m)))

  #model evidence
  mde <- -0.5*(lambda * sum(y^2) - log(lambda) + log(2*pi) + as.vector(m %*% Lambda %*% m) -
                log(det(Lambda)) - as.vector(t(m_hat) %*% Lambda_hat %*% m_hat) + log(det(Lambda_hat)))

  me$Lambda_hat <- Lambda_hat
  me$Lambda_hat_inv <- Lambda_hat_inv
  me$m_hat <- m_hat
  me$model_evidence <- mde

  #set class
  class(me) <- append(class(me),"blm")
  return(me)
}
