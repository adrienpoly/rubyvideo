import Appsignal from '@appsignal/javascript'

const key = import.meta.env.PROD ? '4425c854-a76a-4131-992e-171f7bf653ba' : '10b1f5e6-62a2-4bd8-9431-7698de53c68a'

export const appsignal = new Appsignal({ key })
