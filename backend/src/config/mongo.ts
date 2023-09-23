import mongoose from "mongoose";
import config from "config";

const MONGO_URI = config.get<string>("MONGO_URI");

export const connectDB = async () => {
  try {
    await mongoose.connect(MONGO_URI);
    console.log("Connected to Mongodb!")
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
  return;
};
