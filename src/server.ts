import express, { json as expressJson } from "express";
import cors from "cors";
import { loadRoutes } from "./routes";
import { loadMongoose } from "./config/database";
import path from "path";

// Simulation
import contractsSimulatedRouter from "./simulated/contract/router";
import { initSession } from "./middleware/session";
import { ConsentAgent } from "../../cca/contract-agent/src/ConsentAgent";
import { Agent } from "../../cca/contract-agent/src/Agent";
import { MongoDBProvider } from "contract-agent";

export const startServer = async (testPort?: number) => {
  if (!testPort) loadMongoose();

  const app = express();
  const port = testPort || process.env.PORT || 3000;

  app.set("view engine", "ejs");
  app.set("views", path.join(__dirname, "views"));

  app.use(cors({ origin: true, credentials: true }));
  app.use(expressJson());

  app.set("trust proxy", true);

  app.use(initSession());

  //Consent Agent setup
  Agent.setConfigPath("../consent-agent.config.json", __filename);
  Agent.setProfilesHost("profiles");
  const consentAgent = await ConsentAgent.retrieveService();

  loadRoutes(app);

  // SIMULATING CONTRACT
  app.use("/contracts", contractsSimulatedRouter);

  // Start the server
  const server = app.listen(port, () => {
    //eslint-disable-next-line
    console.log(`Consent manager running on: http://localhost:${port}`);
  });

  return { server, app }; // For tests
};
