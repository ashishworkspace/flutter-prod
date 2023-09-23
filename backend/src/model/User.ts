import { Schema, model } from "mongoose";

const userSchema = new Schema({
  email: {
    required: true,
    type: String,
    unique: true,
    trim: true,
  },
  password: {
    required: true,
    type: String,
  },
  refresh_token: {
    type: String,
    default: null,
  },
  refresh_token_expiry: {
    type: Date,
    default: null,
  },
});

const UserModel = model("Users", userSchema);

export default UserModel;
