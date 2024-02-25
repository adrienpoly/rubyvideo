import Appsignal from '@appsignal/javascript'
import { application } from '../controllers/application'

const key = process.env.NODE_ENV === 'production' ? '4425c854-a76a-4131-992e-171f7bf653ba' : '10b1f5e6-62a2-4bd8-9431-7698de53c68a'

export const appsignal = new Appsignal({ key })

const defaultErrorHandler = application.handleError.bind(application)

// create a ne composed error handler with Appsignal
const appsignalErrorHandler = (error, message, detail = {}) => {
  defaultErrorHandler(error, message, detail)
  appsignal.sendError(error, (span) => { span.setTags({ message }) })
}

// overwrite the default handler with our new composed handler
application.handleError = appsignalErrorHandler
