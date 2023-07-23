{final, prev}:
{
  discord = prev.discord.override {
    withVencord=true;
    withOpenASAR=true;
    };
}
