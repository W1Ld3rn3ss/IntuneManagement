# Release Notes

## 3.0.0 Beta 1 - 2021-04-01

**Breaking changes**

- Dropped support for Azure Branding and MAM/MDM settings...for now
- Import might not work for items exported with previous versions. Some folders are renamed, import is depending on additional information.

**New features**

- Authentication managed by Microsoft Authentication Library (MSAL)
  - Support for switching user 
  - Support for switching tenant. Multi tenant support must be enabled in Settings
  - Token info, Profile picture info support etc.
  - See [MSAL info](MSALInfo.md) for more information
- Support for multiple Views - Intune Management and Intune Info for now...
  - Intune Management - Export/Import/Copy objects in Intune
  - Intune Info - Show information about some objects in Intune
- Improved UI experience
  - Support for resizing the Window
  - Support for searching for objects
  - Refresh objects in the list
  - Scaled popup dialogs
- API management redeveloped from scratch to simplify support for new object types in the future
- Support for new object types (Settings Catalog, Named Locations, Scope Tags, Policy Sets etc.)
- Better support for migrating objects between environments  
  - Group migrations e.g. support for Dynamic Groups, different group types etc.
  - Support for dependency objects e.g. Policy Sets reference other objects like Compliance Settings etc. The import of an object uses exported json files to identify dependent items and map old Id to the new Id in the target environment  
  - Support for migrating Scope Tags (Uses the dependency functionallity so Scope Tags must be Exported/Imported)
  - Better support for migrating Assignments

**Dependencies**

- MSAL - **Microsoft.Identity.Client.dll**. This is included in Az / MSAL.PS modules or it can be installed separately. This release was developed and tested with MSAL version 4.21.0.0. 

## 2.0.0 - 2021-02-01

**Breaking changes**

- Removed support for AzureRM

**New features**

- Support for Az module

**Fixes**

- Allow more than 9 Conditional Access policies. Issue [#5](https://github.com/Micke-K/IntuneManagement/issues/5)
- Include WIP policies. Issue [#7](https://github.com/Micke-K/IntuneManagement/issues/7)
- Import is not working. Issue #6 and [#4](https://github.com/Micke-K/IntuneManagement/issues/4)
- Intune module can now be install with scope user. Issue [#8](https://github.com/Micke-K/IntuneManagement/issues/8)

## 1.0.0

- Intune Management with PowerShell
- Dependencies: Intune and AzureRM PowerShell modules
