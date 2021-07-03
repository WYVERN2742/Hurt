Scriptname hrt_Config extends Quest

; PUBLIC OPTIONS --------------------------------------------------------------------------------------------------


; ---------------------- VERSION 1 ---------------------------------------------

ImageSpaceModifier[] Property hrtImagespaces Auto
{Effect Imagespaces. Index-aligned with hrtImagespaceNames}
string[] Property hrtImagespaceNames Auto
{Effect Names. Index-aligned with hrtImagespaces}

float Property d_hrtHealthIntensity      = 1.0 AutoReadOnly
{Default Health Effect Intensity}
float Property hrtHealthIntensity        = 1.0 Auto Hidden
{Health Effect Intensity}
float Property d_hrtHealthThreshold      = 1.0 AutoReadOnly
{Default Health Effect Threshold}
float Property hrtHealthThreshold        = 1.0 Auto Hidden
{Health Effect Threshold}

float Property d_hrtMagickaIntensity     = 1.0 AutoReadOnly
{Default Magicka Effect Intensity}
float Property hrtMagickaIntensity       = 1.0 Auto Hidden
{Magicka Effect Intensity}
float Property d_hrtMagickaThreshold     = 0.7 AutoReadOnly
{Default Magicka Effect Threshold}
float Property hrtMagickaThreshold       = 0.7 Auto Hidden
{Magicka Effect Threshold}

float Property d_hrtStaminaIntensity     = 0.2 AutoReadOnly
{Default Stamina Effect Intensity}
float Property hrtStaminaIntensity       = 0.2 Auto Hidden
{Stamina Effect Intensity}
float Property d_hrtStaminaThreshold     = 1.0 AutoReadOnly
{Default Stamina Effect Threshold}
float Property hrtStaminaThreshold       = 1.0 Auto Hidden
{Stamina Effect Threshold}

int Property d_hrtHealthEffect           = 1 AutoReadOnly
{Default Health Effect Option}
int Property hrtHealthEffect             = 1 Auto Hidden
{Health Effect Option}
int Property d_hrtMagickaEffect          = 2 AutoReadOnly
{Default Magicka Effect Option}
int Property hrtMagickaEffect            = 2 Auto Hidden
{Magicka Effect Option}
int Property d_hrtStaminaEffect          = 3 AutoReadOnly
{Default Stamina Effect Option}
int Property hrtStaminaEffect            = 3 Auto Hidden
{Stamina Effect Option}
