#' Predict value by bayesian linear model
#'
#' @param model a bayesian model for which prediction is desired.
#' @param newdata new data for which prediction is desired.
#' @param type the type of prediction required.
#' @export
#'
predict.blm <- function(model, newdata, type = "response"){
  tt <- terms(model$formula, data = model$data)
  Terms <- delete.response(tt)
  mm <- model.matrix(Terms, newdata)

  if(type == "response"){
    m_ast <- t(model$m_hat) %*% t(mm)
    ret <- as.vector(m_ast)
  }else if(type == "sd"){
    variance_ast <- model$lambda^-1 + apply(mm %*% model$Lambda_hat_inv * mm, 1, sum)
    ret <- as.vector(sqrt(variance_ast))
  }
  return(ret)
}
