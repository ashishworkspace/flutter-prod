import express from "express";
import config from "config";
import cors from "cors";
import helmet from "helmet";
import { connectDB } from "./config/mongo";
import AppRouter from "./routes";
import morgan from "morgan";

const PORT = config.get<number>("PORT");

const app = express();

app.use(cors());
app.use(helmet());
app.use(express.json());
app.use(morgan('combined'))

app.use("/", AppRouter);

const start = () => {
  app.listen(PORT, () => {
    connectDB();
    console.log(`Fluttery backend running on http://localhost:${PORT}`);
  });
};

start();
