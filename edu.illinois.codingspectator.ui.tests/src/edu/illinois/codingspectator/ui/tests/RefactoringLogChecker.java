/**
 * This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.
 */
package edu.illinois.codingspectator.ui.tests;

import static org.junit.Assert.assertFalse;

import org.eclipse.core.runtime.CoreException;

import edu.illinois.codingspectator.ui.tests.RefactoringLog.LogType;

/**
 * @author Mohsen Vakilian
 * 
 */
public class RefactoringLogChecker {

	private String projectName;

	private RefactoringLog expectedRefactoringLog;

	private RefactoringLog actualRefactoringLog;

	public RefactoringLogChecker(RefactoringLog.LogType logType, String refactoringCategory, String testClassName, String projectName) {
		this.projectName= projectName;
		actualRefactoringLog= new RefactoringLog(logType);

		String logSubFolder= "";

		if (logType == LogType.ECLIPSE) {
			logSubFolder= "/eclipse";
		} else if (logType == LogType.PERFORMED) {
			logSubFolder= "/performed";
		}
		expectedRefactoringLog= RefactoringLogUtils.getExpectedRefactoringLog(refactoringCategory + "/" + testClassName + logSubFolder);
	}

	public void assertLogIsEmpty() {
		assertFalse(actualRefactoringLog.exists());
	}

	public void assertMatch() {
		CapturedRefactoringDescriptor actualRefactoringDescriptor= RefactoringLogUtils.getTheSingleRefactoringDescriptor(actualRefactoringLog, projectName);
		CapturedRefactoringDescriptor expectedRefactoringDescriptor= RefactoringLogUtils.getTheSingleRefactoringDescriptor(expectedRefactoringLog, projectName);
		DescriptorComparator.assertMatches(expectedRefactoringDescriptor, actualRefactoringDescriptor);
	}

	public void clean() throws CoreException {
		actualRefactoringLog.clean();
	}

}