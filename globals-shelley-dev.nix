pkgs: with pkgs; with iohkNix.cardanoLib; rec {

  withMonitoring = false;
  withExplorer = false;

  environmentName = "shelley-dev";

  environmentConfig = rec {
    relays = "relays.${pkgs.globals.domain}";
    genesisFile = ./keys/genesis.json;
    genesisHash = builtins.replaceStrings ["\n"] [""] (builtins.readFile ./keys/GENHASH);
    nodeConfig = lib.recursiveUpdate environments.shelley_qa.nodeConfig {
      ShelleyGenesisFile = genesisFile;
      ShelleyGenesisHash = genesisHash;
      Protocol = "TPraos";
      TraceBlockFetchProtocol = true;
    };
    explorerConfig = mkExplorerConfig environmentName nodeConfig;
  };

  ec2 = {
    credentials = {
      accessKeyIds = {
        IOHK = "dev-deployer";
        dns = "dev-deployer";
      };
    };
  };
}
