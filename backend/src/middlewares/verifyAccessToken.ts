import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import config from "config";

const SECRET_KEY = config.get<string>("SECRET_KEY");

export function verifyAccessToken(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const authHeader = req.headers["authorization"];

  const accessToken = authHeader && authHeader.split(" ")[1];
  if (!accessToken) {
    return res.status(401).json({
      message: "Access token missing",
    });
  }

  jwt.verify(accessToken, SECRET_KEY, (error: any, user: any) => {
    if (error) {
      return res.status(401).json({
        message: "Invalid access token",
      });
    }
    console.log("start - verify");
    (req as any).userId = user.userId;
    console.log("end - verify");
    next();
  });
}
