## main.R
if (!exists("CONFIG.LOADED")) source("Config.R")

# Clean raw data
source("CleanData.R")
# Combined clean data into one large dataset
source("CombineText.R")

# Create N-grams
source("CreateNGram.R")

# Run data summary and exploratory analysis
source("Analysis.R")

# Build prediction model
source("BuildModel.R")

# Make prediction
source("Predict.R")
