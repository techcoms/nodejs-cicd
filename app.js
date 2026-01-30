const express = require("express");
const app = express();
const PORT = 3000;

app.get("/", (req, res) => {
  res.send("🚀 Node.js App Deployed Successfully via AWS CodePipeline!");
});

app.listen(PORT, () => {
  console.log(`App running on port ${PORT}`);
});
