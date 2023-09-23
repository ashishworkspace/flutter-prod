import { NextFunction, Request, Response, Router } from "express";
import UserModel from "../model/User";
import bcrypt from "bcryptjs";
import config from "config";
import jwt from "jsonwebtoken";
import { verifyAccessToken } from "../middlewares/verifyAccessToken";

const router = Router();
const SALT_LEVEL = config.get<number>("SALT_LEVEL");
const SECRET_KEY = config.get<string>("SECRET_KEY");
const REFRESH_TOKEN_KEY = config.get<string>("REFRESH_TOKEN_KEY");

router.post("/login", async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
    const user = await UserModel.findOne({ email });

    if (!user) {
      return res.status(404).json({
        message: `${email} email not found`,
      });
    }
    const checkPassword = await bcrypt.compare(password, user.password);
    if (!checkPassword) {
      return res.status(404).json({
        message: "Password is incorrect!",
      });
    }

    // access token
    const access_token = jwt.sign({ userId: user.id }, SECRET_KEY, {
      expiresIn: "30s",
    });
    // refresh token
    const refresh_token = jwt.sign({ userId: user.id }, REFRESH_TOKEN_KEY, {
      expiresIn: "1d",
    });

    const refreshTokenExpiration = new Date();
    refreshTokenExpiration.setDate(refreshTokenExpiration.getDate() + 1);

    user.refresh_token = refresh_token;
    user.refresh_token_expiry = refreshTokenExpiration;
    user.save();

    res.status(200).json({
      access_token,
      refresh_token,
    });
  } catch (error) {
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});

router.post("/signup", async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
    const isUserPresent = await UserModel.findOne({ email });

    if (isUserPresent) {
      return res.status(409).json({
        message: `${email} already exist`,
      });
    }

    const hashPasssword = await bcrypt.hash(password, SALT_LEVEL);
    const user = await UserModel.create({
      email,
      password: hashPasssword,
    });
    user.save();
    res.status(200).json({
      message: "ok",
    });
  } catch (error) {
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});

router.post("/refresh-token", async (req: Request, res: Response) => {
  try {
    const { refresh_token } = req.body;

    const user = await UserModel.findOne({ refresh_token });

    if (!user) {
      return res.status(401).json({
        message: "Invalid refresh token",
      });
    }

    const currentDateTime = new Date();
    if (currentDateTime > user.refresh_token_expiry) {
      user.refresh_token = null!;
      user.refresh_token_expiry = null!;
      await user.save();

      return res.status(401).json({
        message: "Refresh token has expired",
      });
    }

    const access_token = jwt.sign({ userId: user.id }, SECRET_KEY, {
      expiresIn: "30s",
    });

    res.status(200).json({
      access_token,
    });
  } catch (error) {
    res.status(500).json({
      message: "Internal Server Error",
    });
  }
});

router.get("/user", verifyAccessToken, (req: Request, res: Response) => {
  console.log("user");
  console.log("start - user");
  const userId = (req as any).userId;
  console.log("end - user");
  res.json({ userId: userId });
});

export default router;
