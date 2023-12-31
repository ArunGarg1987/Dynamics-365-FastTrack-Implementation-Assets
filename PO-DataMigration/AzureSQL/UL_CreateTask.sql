/****** Object:  StoredProcedure [dbo].[UL_CreateTask]    Script Date: 6/12/2023 2:00:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UL_CreateTask]
AS


TRUNCATE TABLE UL_Task

INSERT INTO UL_Task
SELECT 
   Nr,
   newid() as Id, 
   TaskName,ProjectId,ProjectBucket,
   Effort,
   Effort as EffortRemaining,
   0.0 as EffortCompleted,
   ScheduledStart,ScheduledEnd,
   192350000 as LinkStatus,
   ParentTask,
   CAST(0x0 AS UNIQUEIDENTIFIER) as ParentId,
   Nr as WBSNr,
   (Effort / 8) as msdyn_duration, 
   ScheduledEnd as msdyn_finish, 
   1 as msdyn_outlinelevel, 
   (Effort / 8) * 24 * 60 as msdyn_scheduledduration,
   ScheduledStart as msdyn_start
FROM
   CU_Task task
JOIN
   DL_Project project
ON
   task.ProjectName = project.ProjectName
LEFT JOIN (
   SELECT 
      ProjectBucket,Project
   FROM
      DL_ProjectBucket 
   WHERE
      Name = 'Bucket 1') as bucket
ON
  project.ProjectId = bucket.Project
 
UPDATE child
SET
   child.ParentId = ( SELECT Id From UL_Task 
                      WHERE
			 ProjectId = child.ProjectId and 
			 Nr = child.ParentTask)
FROM
    UL_Task child

