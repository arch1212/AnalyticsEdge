y = matrix(nrow = 7, ncol = 4)
for(x in 1:7){
y[x,] = match(c("dean", "kerry", "edward", "democrat") ,names(tail(sort(colMeans(spl1[[x]])))))
}
print(y)