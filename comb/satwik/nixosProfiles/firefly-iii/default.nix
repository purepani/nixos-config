{
  inputs,
  cell,
}: {
  virtualisation.oci-containers.containers = {
    firefly-iii = {
      image = "fireflyiii/core";
      #imageFile = inputs.nixpkgs.dockerTools.buildImage {
      #  name = "fireflyiii";
      #  fromImage = ./docker-compose.yml;
      #};
      environmentFiles = [./.env ./.db.env];
      ports = ["8080"];
    };
  };
}
