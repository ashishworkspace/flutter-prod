import { Router } from "express";
import AuthRouter from "./auth.routes";

const router = Router();

router.use("/api", AuthRouter);

export default router;
