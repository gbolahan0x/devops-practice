const express = require("express");

const app = express();
const port = process.env.PORT || 3000;

app.get("/", (_request, response) => {
  response.json({
    message: "Week 3 Docker Compose app is running",
    environment: process.env.NODE_ENV || "development"
  });
});

app.get("/health", (_request, response) => {
  response.status(200).json({ status: "healthy" });
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});