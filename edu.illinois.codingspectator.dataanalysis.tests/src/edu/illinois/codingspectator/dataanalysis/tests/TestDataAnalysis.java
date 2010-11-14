/**
 * This file is licensed under the University of Illinois/NCSA Open Source License. See LICENSE.TXT for details.
 */
package edu.illinois.codingspectator.dataanalysis.tests;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import junit.framework.Assert;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import edu.illinois.codingspectator.dataanalysis.LogConsolidator;

/**
 * 
 * @author Roshanak Zilouchian
 * @author Mohsen Vakilian
 * 
 */
public class TestDataAnalysis {

	String test01Dir= LogConsolidator.join("resources", "01");

	String test01InputDir= LogConsolidator.join(test01Dir, "input");

	String test01ActualDir= LogConsolidator.join(test01Dir, "actual-output");

	String test01ExpectedDir= LogConsolidator.join(test01Dir, "expected-output");

	String test01ActualCanceled= LogConsolidator.join(test01ActualDir, "canceled.xml");

	String test01ExpectedCanceled= LogConsolidator.join(test01ExpectedDir, "canceled.xml");

	String test01ActualPerformed= LogConsolidator.join(test01ActualDir, "performed.xml");

	String test01ExpectedPerformed= LogConsolidator.join(test01ExpectedDir, "performed.xml");

	String test01ActualDotRefactorings= LogConsolidator.join(test01ActualDir, ".refactorings.xml");

	String test01ExpectedDotRefactorings= LogConsolidator.join(test01ExpectedDir, ".refactorings.xml");

	@Before
	public void setUp() throws IOException {
		new File(test01ActualDir).mkdir();
		LogConsolidator.main(new String[] { "-i", test01InputDir, "-o", test01ActualDir, "-n", "canceled", "-n", "performed", "-n", ".refactorings" });
	}

	@Test
	public void shouldCombinePerformedRefactoringLogs() throws IOException {
		compareFiles(test01ExpectedPerformed, test01ActualPerformed);
	}

	@Test
	public void shouldCombineCanceledRefactoringLogs() throws IOException {
		compareFiles(test01ExpectedCanceled, test01ActualCanceled);
	}

	@Test
	public void shouldCombineDotRefactoringLogs() throws IOException {
		compareFiles(test01ExpectedDotRefactorings, test01ActualDotRefactorings);
	}

	@After
	public void tearDown() {
		new File(test01ActualDir).delete();
	}

	private void compareFiles(String expectedFilePath, String actualFilePath) throws IOException {
		Assert.assertEquals(getContents(expectedFilePath), getContents(actualFilePath));
	}

	private String getContents(String filePath) throws IOException {
		BufferedReader fileReader= new BufferedReader(new FileReader(filePath));
		StringBuilder sb= new StringBuilder();
		String line;

		while ((line= fileReader.readLine()) != null) {
			sb.append(line);
			sb.append("\n");
		}

		fileReader.close();
		return sb.toString();
	}


}
