
public class HerculesProjectile extends ExplodingBullet {

  protected cb func OnShoot(eventData: ref<gameprojectileShootEvent>) -> Bool {
    this.OnShootTarget(eventData as gameprojectileShootTargetEvent);
  }

  protected cb func OnShootTarget(eventData: ref<gameprojectileShootTargetEvent>) -> Bool {
    let energyLossFactorAfterCollision: Float;
    let gravitySimulation: Float;
    let startVelocity: Float;
    this.GeneralLaunchSetup(eventData);
    gravitySimulation = this.GetProjectileTweakDBFloatParameter("gravitySimulation");
    startVelocity = this.GetProjectileTweakDBFloatParameter("startVelocity");
    energyLossFactorAfterCollision = this.GetProjectileTweakDBFloatParameter("energyLossFactorAfterCollision");
    this.ParabolicLaunch(eventData, gravitySimulation, startVelocity, energyLossFactorAfterCollision);
  }
}
