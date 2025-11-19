import '../../domain/params/create_application_params.dart';
import '../models/requests/candidate_info_model.dart';
import '../models/requests/create_application_request_model.dart';

/// Maps domain CreateApplicationParams to data layer CreateApplicationRequestModel
extension CreateApplicationParamsMapper on CreateApplicationParams {
  CreateApplicationRequestModel toRequestModel() {
    return map(
      alpinaDigitalAccess: (params) =>
          CreateApplicationRequestModel.alpinaAccess(
            desiredStartDate: params.desiredStartDate,
            comment: params.comment,
            alpinaDigitalPrevAccessCode: params.alpinaDigitalPrevAccessCode,
            agreementAcceptance: params.agreementAcceptance,
          ),
      courierDelivery: (params) =>
          CreateApplicationRequestModel.courierDelivery(
            deliveryType: params.deliveryType,
            tripPurposesCode: params.tripPurposesCode,
            office: params.office,
            deliveryDate: params.deliveryDate,
            urgency: params.urgency,
            recepientCompanyName: params.recepientCompanyName,
            deliveryAddress: params.deliveryAddress,
            recepientNameContact: params.recepientNameContact,
            recepientPhoneNumber: params.recepientPhoneNumber,
            recepientEmail: params.recepientEmail,
            comments: params.comments,
            choiceExplanation: params.choiceExplanation,
            contentDescription: params.contentDescription,
          ),
      unplannedTraining: (params) =>
          CreateApplicationRequestModel.unplannedTraining(
            supervisorEmployee: params.supervisorEmployee,
            chief: params.chief,
            contractor: params.contractor,
            notListOrganizers: params.notListOrganizers,
            organizer: params.organizer,
            eventTitle: params.eventTitle,
            trainingTypeCode: params.trainingTypeCode,
            trainingFormCode: params.trainingFormCode,
            startDateTraining: params.startDateTraining,
            endDateTraining: params.endDateTraining,
            exactDatesUnknown: params.exactDatesUnknown,
            trainingMonthCode: params.trainingMonthCode,
            costInt: params.costInt,
            purposeTraining: params.purposeTraining,
            linkCourse: params.linkCourse,
            employee: params.employee,
            groupEmployees: params.groupEmployees,
          ),
      referralProgram: (params) =>
          CreateApplicationRequestModel.referralProgram(
            idVacancy: params.idVacancy,
            fullName: params.fullName.toModel(),
            resumeFile: params.resumeFile,
            linkToResume: params.linkToResume,
            comment: params.comment,
          ),
      violation: (params) => CreateApplicationRequestModel.violation(
        securityLevelId: params.securityLevelId,
        summary: params.summary,
        description: params.description,
      ),
      absence: (params) => CreateApplicationRequestModel.absence(
        category: params.category,
        note: params.note,
        fromDateTime: params.fromDateTime,
        toDateTime: params.toDateTime,
      ),
      businessTrip: (params) => CreateApplicationRequestModel.businessTrip(
        startDate: params.startDate,
        endDate: params.endDate,
        departure: params.departure,
        destination: params.destination,
        financeDivisionTripCode: params.financeDivisionTripCode,
        financeDivisionTripString: params.financeDivisionTripString,
        tripPurposeId: params.tripPurposeId,
        tripPurposeString: params.tripPurposeString,
        activityType: params.activityType,
        plannedEvents: params.plannedEvents,
        urgency: params.urgency,
        selectionHelpTripCode: params.selectionHelpTripCode,
        comment: params.comment,
        files: params.files,
        travelers: params.travelers,
        country: params.country,
        legalEntity: params.legalEntity,
      ),
    );
  }
}

/// Maps domain CandidateInfo to data layer CandidateInfoModel
extension CandidateInfoMapper on CandidateInfo {
  CandidateInfoModel toModel() {
    return CandidateInfoModel(
      lastName: lastName,
      firstName: firstName,
      middleName: middleName,
    );
  }
}
